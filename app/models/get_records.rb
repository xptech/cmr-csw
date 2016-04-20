class GetRecords < BaseCswModel
  # Supported ISO queryables
  # TODO Add more queryables here,TempExtent_begin, TempExtent_end
  RESULT_TYPES = %w(ScienceKeywords)

  @request_body_xml
  @filter
  @start_position
  @result_type
  @max_records
  # for now it only supports the AND between ALL CMR query parameters
  @cmr_query_hash

  def initialize params, request
    super(params, request)
    @cmr_query_hash = Hash.new
  end

  def is_valid
    if (!@request_body.empty? && @request.post?)
      validate_post_request
      process_post_request
    else
      if (@request.get?)
        ex = OwsException.new(INVALID_REQUEST_TYPE_GET_RECORDS, 'GetRecords only supports POST requests', 'CMR CSW:GetRecords.is_valid', 400)
        raise ex
      end
    end
  end

  def find
    #cmr_params = to_cmr_collection_params
    Rails.logger.info "CMR Params: #{@cmr_query_hash}"
    response = nil
    begin
      time = Benchmark.realtime do
        query_url = "#{Rails.configuration.cmr_search_endpoint}/collections"
        Rails.logger.info "RestClient call to CMR endpoint: #{query_url}?#{@cmr_query_hash.to_query}"
        response = RestClient::Request.execute :method => :get, :url => "#{query_url}?#{@cmr_query_hash.to_query}",
                                               :verify_ssl => OpenSSL::SSL::VERIFY_NONE,
                                               :headers => {:client_id => Rails.configuration.client_id,
                                                            :accept => 'application/iso19115+xml'}
      end
      Rails.logger.info "CMR dataset search took : #{time.to_f.round(2)} seconds"
    rescue RestClient::Exception => e
      Rails.logger.error("CMR call failure httpStatus: #{e.http_code} message: #{e.message} response: #{e.response}")
      # TODO add error handling
      throw OwsException.new(INVALID_REQUEST_TYPE_GET_RECORDS, 'GetRecords only supports POST requests', 'CMR CSW:GetRecords.is_valid', 400)
    end

    document = Nokogiri::XML(response)
    # This model is an array of collections in the iso19115 format. It's up to the view to figure out how to render it
    # Each gmi:MI_Metadata element is a collection
    model = OpenStruct.new
    # didn't convert to UTC Time.now.utc.iso8601
    model.server_timestamp = Time.now.iso8601
    model.output_schema = @output_schema
    model.response_element = @response_element
    model.number_of_records_matched = document.at_xpath('/results/hits').text.to_i
    # will include as a comment in the csw response XML
    model.cmr_search_duration_millis = document.at_xpath('/results/took').text.to_i
    result_nodes = document.root.xpath('/results/result')
    model.number_of_records_returned = result_nodes.blank? ? 0 : result_nodes.size
    #TODO handle edge conditions better, wait for CMR navigation by index functionality
    if(model.number_of_records_matched > model.number_of_records_returned)
      model.next_record = 1 + model.number_of_records_returned
    else
      # indicates that ALL records have been returned
      model.next_record = 0
    end
    model.raw_collections_doc = document
    return model
  end

  def to_cmr_collection_params
    cmr_params = {}

    cmr_params
  end

  private

  def validate_post_request
    Rails.logger.info("Validating GetRecords POST request")
    exception_message = nil
    begin
      @request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }
      root_name = @request_body_xml.root.name
      @service = @request_body_xml.root['service']
      @version = @request_body_xml.root['version']

      output_schema_value = @request_body_xml.root['outputSchema']
      @output_schema = output_schema_value.blank? ? 'http://www.isotc211.org/2005/gmi' : output_schema_value
      # defaults to 'hits' (per spec)
      result_type_value = @request_body_xml.root['resultType']
      @result_type = result_type_value.blank? ? 'hits' : result_type_value

      # defaults to 'brief' (per spec)
      element_set_name_value =  @request_body_xml.at_xpath("//csw:GetRecords//csw:Query//csw:ElementSetName",
                                                            'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      @response_element = element_set_name_value.blank? ? 'brief' : element_set_name_value.text

      start_position_value = @request_body_xml.root['startPosition']
      # defaults to 1 (per spec)
      @start_position = start_position_value.blank? ? '1' : start_position_value

      max_records_value = @request_body_xml.root['maxRecords']
      # defaults to 10 (per spec)
      @max_records = max_records_value.blank? ? '10' : max_records_value

      if @service == nil || @service.upcase != 'CSW'
        exception_message = "The CSW GetRecords POST request must contain the 'service=CSW' attribute for the 'GetRecords' root element."
      end
      if root_name.upcase != 'GETRECORDS'
        if (exception_message != nil)
          exception_message = exception_message + "The CSW GetRecords POST request must contain the 'GetRecords' root element."
        else
          exception_message = "The CSW GetRecords POST request must contain the 'GetRecords' root element."
        end
      end
      if @version == nil || @version != '2.0.2'
        if (exception_message != nil)
          exception_message = exception_message + "The CMR CSW 'GetRecords' POST request must contain the 'version=2.0.2' attribute for the 'GetRecords' root element."
        else
          exception_message = "The CMR CSW GetRecords POST request must contain the 'version=2.0.2' attribute for the 'GetRecords' root element."
        end
      end
      if (exception_message == nil)
        return true
      else
        ex = OwsException.new(INVALID_POST_REQUEST_GET_RECORDS, exception_message, 'CMR CSW:GetRecords.validate_post_request', 400)
        raise ex
      end
    rescue Nokogiri::XML::SyntaxError => e
      Rails.logger.error("Invalid XML in POST request body:  #{@request_body}")
      ex = OwsException.new(INVALID_POST_REQUEST_GET_RECORDS, " #{e.inspect}", "CMR CSW:GetRecords.validate_post_request", 400)
      raise ex
    end
    return false
  end

  def process_post_request
    #TODO add support of various queryables and filter criteria in csw:Query element
    @filter = @request_body_xml.at_xpath("//csw:GetRecords//csw:Query//csw:Constraint//ogc:Filter",
                                         'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                         'ogc' => 'http://www.opengis.net/ogc')
    if @filter != nil
      Rails.logger.info("Processing filter in GetRecords POST request:  #{@request_body}")
      filterHelper = OgcFilter.new(@filter, @cmr_query_hash)
      filterHelper.process_any_text
    else
      Rails.logger.info("No results filtering criteria specified in GetRecords POST request:  #{@request_body}")
    end
  end
end