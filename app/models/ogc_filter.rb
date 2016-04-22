class OgcFilter
  @ogc_filter
  @cmr_query_hash

  def initialize (filter, cmr_query_hash)
    @ogc_filter = filter
    @cmr_query_hash = cmr_query_hash
  end

  def process_any_text
    cmr_keyword_param = ISO_QUERYABLES_TO_CMR_QUERYABLES["AnyText"][1]
    any_text = @ogc_filter.xpath('//ogc:PropertyName[contains(text(), "AnyText")]', 'ogc' => 'http://www.opengis.net/ogc')
    if (any_text != nil && any_text[0] != nil)
      any_text_literal_node = any_text[0].next_element
      if (any_text_literal_node != nil)
        literal_value = any_text_literal_node.text
        # the cmr keyword only supports a single value and not an array
        @cmr_query_hash["#{cmr_keyword_param}"] = literal_value
      end
    end
    Rails.logger.info("OgcFilter.process_any_text: #{@cmr_query_hash}")
  end

  # CMR query is: bounding_box =  lower left longitude, lower left latitude, upper right longitude, upper right latitude.
  # gml iso:boundingbox envelope is:
  # <gml:lowerCorner>LONG LAT</gml:lowerCorner>
  # <gml:upperCorner>LONG (-180 to + 180) LAT (-90 to +90)</gml:upperCorner>
  def process_spatial_bounding_box
    cmr_bounding_box_param = ISO_QUERYABLES_TO_CMR_QUERYABLES["BoundingBox"][1]
    bounding_box = @ogc_filter.xpath('//ogc:PropertyName[contains(text(), "BoundingBox")]', 'ogc' => 'http://www.opengis.net/ogc')
    if (bounding_box != nil && bounding_box[0] != nil)
      bounding_box_envelope_node = bounding_box[0].next_element
      if (bounding_box_envelope_node != nil)
        iso_bounding_box = IsoBoundingBox.new(bounding_box_envelope_node)
        if(iso_bounding_box.valid?)
          # the cmr bounding_box only supports a single value and not an array
          @cmr_query_hash["#{cmr_bounding_box_param}"] = iso_bounding_box.to_cmr
        else
          error_message = "OgcFilter.process_spatial_bounding_box errors: #{iso_bounding_box.errors.full_messages.to_s}"
          Rails.logger.error(error_message)
          raise OwsException.new('InvalidParameterValue', "#{error_message}", "iso:BoundingBox", '400')
        end
      end
    end
    Rails.logger.info("OgcFilter.process_spatial_bounding_box: #{@cmr_query_hash}")
  end

  # CMR temporal query syntax
  # 2000-01-01T10:00:00Z, means AFTER, so does ISO 2000-01-01T10:00:00Z/
  # ,2010-03-10T12:00:00Z means BEFORE, so does ISO /2010-03-10T12:00:00Z
  # 2000-01-01T10:00:00Z,2010-03-10T12:00:00Z means BETWEEN, so does ISO 2000-01-01T10:00:00Z/2010-03-10T12:00:00Z
  # For temporal range search, the default is inclusive on the range boundaries. This can be changed by specifying
  # exclude_boundary option with options[temporal][exclude_boundary]=true. This option has no impact on periodic
  # temporal searches, which CMR CSW will not support initially.
  def process_temporal
    cmr_temporal_param = ISO_QUERYABLES_TO_CMR_QUERYABLES["TempExtent_begin"][1] # same CMR mapping exists for TempExtent_end
    time_start_params = extract_operand_filter_data("TempExtent_begin")
    time_end_params = extract_operand_filter_data("TempExtent_end")
    temporal_query_string = nil
    if (time_start_params.size == 2)
      temporal_query_string = process_start_temporal(time_start_params)
    end
    if (time_end_params.size == 2)
      temporal_query_string = process_end_temporal(time_end_params, temporal_query_string)
    end
    if (temporal_query_string != nil)
      @cmr_query_hash["#{cmr_temporal_param}"] = temporal_query_string
    end
    Rails.logger.info("OgcFilter.process_temporal: #{@cmr_query_hash}")
  end

  private
  SUPPORTED_TEMPORAL_OPERATORS = %w(PropertyIsGreaterThanOrEqualTo PropertyIsGreaterThan PropertyIsLessThanOrEqualTo PropertyIsLess)
  # the property_name is the string that we are interested in (AnyText, TempExtent_begin, TempExtent_end etc.)
  # assume that there is just ONE property_name node that we are operating on
  def extract_operand_filter_data(property_name)
    filter_data = {}
    property_name_xpath = "//ogc:PropertyName[contains(text(), '#{property_name}')]"
    property_name_node_set = @ogc_filter.xpath(property_name_xpath, 'ogc' => 'http://www.opengis.net/ogc')
    if (property_name_node_set != nil && property_name_node_set[0] != nil)
      property_literal_node = property_name_node_set[0].next_element
      property_parent_operator_node = property_name_node_set[0].parent
      if (property_literal_node != nil)
        filter_data[:literal_value] = property_literal_node.text
      end
      if (property_parent_operator_node != nil)
        filter_data[:operator] = property_parent_operator_node.name
      end
    end
    filter_data
  end

  def process_start_temporal(time_start_hash)
    query_string = nil
    begin_value = time_start_hash[:literal_value]
    validate_iso_date(begin_value)
    #TODO add ISO format parsing for begin_value
    operator = time_start_hash[:operator]
    case operator
      when "PropertyIsGreaterThanOrEqualTo"
        query_string = "#{begin_value}/"
      when "PropertyIsGreaterThan"
        # TODO modify when CMR supports boundary exclusion for individual temporal query component, currently the
        # boundary exlcusion applies to ALL temporal query components
        query_string = "#{begin_value}/"
      when "PropertyIsLessThanOrEqualTo"
        query_string = "/#{begin_value}"
      when "PropertyIsLessThan"
        # TODO modify when CMR supports boundary exclusion for individual temporal query component, currently the
        # boundary exlcusion applies to ALL temporal query components
        query_string = "/#{begin_value}"
      else
        error_message = "OgcFilter.process_start_temporal: invalid operator value #{operator} for TempExtent_begin"
        Rails.logger.error(error_message)
        # use 'None' instead of ommiting the locator
        raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
    end
    query_string
  end

  def process_end_temporal(time_end_hash, query_string)
    end_value = time_end_hash[:literal_value]
    validate_iso_date(end_value)
    operator = time_end_hash[:operator]
    if (query_string == nil)
      # we have no TempExtent_begin queryable
      case operator
        when "PropertyIsGreaterThanOrEqualTo"
          query_string = "#{end_value}/"
        when "PropertyIsGreaterThan"
          # TODO modify when CMR supports boundary exclusion for individual temporal query component, currently the
          # boundary exlcusion applies to ALL temporal query components
          query_string = "#{end_value}/"
        when "PropertyIsLessThanOrEqualTo"
          query_string = "/#{end_value}"
        when "PropertyIsLessThan"
          # TODO modify when CMR supports boundary exclusion for individual temporal query component, currently the
          # boundary exlcusion applies to ALL temporal query components
          query_string = "/#{end_value}"
        else
          Rails.logger.error("OgcFilter.process_end_temporal: invalid operator value #{operator}")
          # use 'None' instead of ommiting the locator
          raise OwsException.new('NoApplicableCode', "Operator #{operator} not supported for TempExtent_end", 'None', '400')
      end
    else
      # we already have a TempExtent_begin queryable
      begin_temporal_after_operator = query_string.last == '/' ? true : false
      begin_temporal_before_operator = query_string.first == '/' ? true : false
      case operator
        when "PropertyIsGreaterThanOrEqualTo"
          if begin_temporal_after_operator
            # begin is AFTER, end is AFTER, need begin is AFTER, end is BEFORE
            error_message = "OgcFilter.process_end_temporal (A AFTER/AFTER): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
          else
            # begin is BEFORE, end is AFTER
            error_message = "OgcFilter.process_end_temporal (B BEFORE/AFTER): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
          end
        when "PropertyIsGreaterThan"
          if begin_temporal_after_operator
            # begin is AFTER, end is AFTER, need begin is AFTER, end is BEFORE
            error_message = "OgcFilter.process_end_temporal (C AFTER/AFTER): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
          else
            # begin is BEFORE, end is AFTER
            error_message = "OgcFilter.process_end_temporal (C BEFORE/AFTER): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
          end
        when "PropertyIsLessThanOrEqualTo"
          if begin_temporal_after_operator
            # begin is AFTER, end is BEFORE OK
            begin_date = DateTime.parse(query_string.gsub('/',''))
            end_date = DateTime.parse(end_value)
            if(begin_date < end_date)
              query_string = query_string + end_value
            else
              error_message = "OgcFilter.process_end_temporal: TempExtent_begin date #{begin_date} must be before the " +
                  "TempExtent_end date #{end_date}"
              Rails.logger.error(error_message)
              # use 'None' instead of ommiting the locator
              raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
            end
          else
            # begin is BEFORE, end is BEFORE
            error_message = "OgcFilter.process_end_temporal (E BEFORE/BEFORE): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
          end
        when "PropertyIsLessThan"
          if begin_temporal_after_operator
            # begin is AFTER, end is BEFORE OK
            begin_date = DateTime.parse(query_string.gsub('/',''))
            end_date = DateTime.parse(end_value)
            if(begin_date < end_date)
              query_string = query_string + end_value
            else
              error_message = "OgcFilter.process_end_temporal: TempExtent_begin date #{begin_date} must be before the " +
                  "TempExtent_end date #{end_date}"
              Rails.logger.error(error_message)
              # use 'None' instead of ommiting the locator
              raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
            end
          else
            # begin is BEFORE, end is BEFORE
            error_message = "OgcFilter.process_end_temporal (F BEFORE/BEFORE): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
          end
        else
          error_message = "OgcFilter.process_end_temporal: invalid operator value #{operator} for TempExtent_end"
          Rails.logger.error(error_message)
          # use 'None' instead of ommiting the locator
          raise OwsException.new('NoApplicableCode', "#{error_message}", 'None', '400')
      end
    end
    query_string
  end

  def validate_iso_date(date_string)
    begin
      # DateTime.parse(date).iso8601 is too lax, we must enforce CMR ISO 8601 format 2016-09-06T23:59:59Z
      d = DateTime.strptime(date_string, '%Y-%m-%dT%H:%M:%SZ')
    rescue ArgumentError => e
      error_message = "OgcFilter.validate_iso_date #{date_string} is NOT in the required ISO8601 format yyyy-MM-ddTHH:mm:ssZ"
      Rails.logger.error(error_message)
      raise OwsException.new('InvalidParameterValue', "#{error_message}", "#{date_string}", '400')
    end
  end

end