class GetRecords < BaseCswModel

  def initialize params, request
    super(params, request)
  end

  def is_valid
    if(!@request_body.empty? && @request.post?)
      validate_post_request
    else
      if(@request.get?)
        ex = OwsException.new(INVALID_REQUEST_TYPE_GET_RECORDS, 'GetRecords only supports POST requests', 'CMR CSW:GetRecords.is_valid', 400)
        raise ex
      end
    end
  end

  def submit
    cmr_params = to_cmr_collection_params
    Rails.logger.info "CMR Params: #{cmr_params}"
    response = nil
    begin
      time = Benchmark.realtime do
        query_url = "#{Rails.configuration.cmr_search_endpoint}/collections"
        Rails.logger.info "RestClient call to CMR endpoint: #{query_url}?#{cmr_params.to_query}"
        response = RestClient::Request.execute :method => :get, :url => "#{query_url}?#{cmr_params.to_query}",
                                               :verify_ssl => OpenSSL::SSL::VERIFY_NONE,
                                               :headers => {:client_id => Rails.configuration.client_id,
                                                            :accept => 'application/iso19115+xml'}
      end
      Rails.logger.info "CMR dataset search took : #{time.to_f.round(2)} seconds"
    rescue RestClient::Exception => e
      Rails.logger.error("CMR call failure httpStatus: #{e.http_code} message: #{e.message} response: #{e.response}")
      # TODO add error handling
      throw new OwsException()
    end

    document = Nokogiri::XML(response)
    # This model is an array of collections in the iso19115 format. It's up to the view to figure out how to render it
    # Each gmi:MI_Metadata element is a collection
    model = OpenStruct.new
    model.output_schema = @output_schema
    model.response_element = @response_element
    model.collections = []
    document.root.xpath('/results/result/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi').each do |collection|
      model.collections.append(collection.to_xml)
    end

    return model
  end

  def to_cmr_collection_params
    cmr_params = {}
    # TODO add keyword, spatial and temporal in subsequent work

    cmr_params
  end

private

  def validate_post_request
    Rails.logger.info("Validating GetRecords POST request")
    exception_message = nil
    begin
      request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }
      root_name = request_body_xml.root.name
      service_attribute = request_body_xml.root['service']
      version_attribute = request_body_xml.root['version']
      if service_attribute == nil || service_attribute.upcase != 'CSW'
        exception_message = "The CSW GetRecords POST request must contain the 'service=CSW' attribute for the 'GetRecords' root element."
      end
      if root_name.upcase != 'GETRECORDS'
        if(exception_message != nil)
          exception_message = exception_message + "The CSW GetRecords POST request must contain the 'GetRecords' root element."
        else
          exception_message = "The CSW GetRecords POST request must contain the 'GetRecords' root element."
        end
      end
      if version_attribute == nil || version_attribute != '2.0.2'
        if(exception_message != nil)
          exception_message = exception_message + "The CMR CSW 'GetRecords' POST request must contain the 'version=2.0.2' attribute for the 'GetRecords' root element."
        else
          exception_message = "The CMR CSW GetRecords POST request must contain the 'version=2.0.2' attribute for the 'GetRecords' root element."
        end
      end
      if(exception_message == nil)
        return true
      else
        ex = OwsException.new(INVALID_POST_REQUEST_GET_RECORDS, exception_message, 'CMR CSW:GetRecords.validate_post_request', 400)
        raise ex
      end
    rescue Nokogiri::XML::SyntaxError => e
      Rails.logger.error("Invalid XML in POST request body:  #{@request_body}")
      ex = OwsException.new(INVALID_POST_REQUEST_GET_RECORDS, " #{e.inspect}", "CMR CSW:GetRecords.validate_post_request",400)
      raise ex
    end
    return false
  end

end