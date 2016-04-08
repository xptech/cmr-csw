class GetRecords
  @request_params
  @request
  @request_body

  def initialize params, request
    @request_params = params
    @request = request
    @request_body = request.body.read
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

  def get_model
    model = OpenStruct.new
    # Add additional items below
    return model
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