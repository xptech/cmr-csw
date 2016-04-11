class GetCapability
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
        validate_get_request
      else
        ex = OwsException.new(INVALID_REQUEST_TYPE_GET_CAPABILITIES, 'GetCapabilities only supports GET and POST requests', 'CMR CSW:GetCapability.is_valid', 400)
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
    Rails.logger.info("Validating GetCapabilities POST request")
    exception_message = nil
    begin
      request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }
      root_name = request_body_xml.root.name
      service_attribute = request_body_xml.root['service']
      version_attribute = request_body_xml.root['version']
      if service_attribute == nil || service_attribute.upcase != 'CSW'
        exception_message = "The CSW GetCapabilities POST request must contain the 'service=CSW' attribute for the 'GetCapabilities' root element."
      end
      if root_name.upcase != 'GETCAPABILITIES'
        if(exception_message != nil)
          exception_message = exception_message + "The CSW GetCapabilities POST request must contain the 'GetCapabilities' root element."
        else
          exception_message = "The CSW GetCapabilities POST request must contain the 'GetCapabilities' root element."
        end
      end
      if version_attribute == nil || version_attribute != '2.0.2'
        if(exception_message != nil)
          exception_message = exception_message + "The CMR CSW GetCapabilities POST request must contain the 'version=2.0.2' attribute for the 'GetCapabilities' root element."
        else
          exception_message = "The CMR CSW GetCapabilities POST request must contain the 'version=2.0.2' attribute for the 'GetCapabilities' root element."
        end
      end
      if(exception_message == nil)
        return true
      else
        ex = OwsException.new(INVALID_POST_REQUEST_GET_CAPABILITIES, exception_message, 'CMR CSW:GetCapability.validate_post_request', 400)
        raise ex
      end
    rescue Nokogiri::XML::SyntaxError => e
      Rails.logger.error("Invalid XML in POST request body:  #{@request_body}")
      ex = OwsException.new(INVALID_POST_REQUEST_GET_CAPABILITIES, " #{e.inspect}", "CMR CSW:GetCapability.validate_post_request",400)
      raise ex
    end
    return false
  end

  def validate_get_request
    Rails.logger.info("Validating GetCapabilities GET request")
    exception_message = nil
    service = @request_params[:service]
    if service == nil || service.upcase != 'CSW'
      exception_message = "The CSW GetCapabilities GET request must contain the 'service=CSW' query parameter."
    end
    if(@request_params[:request].upcase != 'GETCAPABILITIES')
      if(exception_message != nil)
        exception_message = exception_message + "The CSW GetCapabilities GET request must contain the 'request=GetCapabilities' query parameter."
      else
        exception_message = "The CSW GetCapabilities GET request must contain the 'request=GetCapabilities' query parameter."
      end
    end
    version = @request_params[:version]
    if version == nil || version != '2.0.2'
      if(exception_message != nil)
        exception_message = exception_message + "The CMR CSW GetCapabilities GET request must contain the 'version=2.0.2' query parameter."
      else
        exception_message = "The CMR CSW GetCapabilities GET request must contain the 'version=2.0.2' query parameter."
      end
    end
    if(exception_message == nil)
      return true
    else
      ex = OwsException.new(INVALID_GET_REQUEST_GET_CAPABILITIES, exception_message, 'CMR CSW:GetCapability.validate_get_request', 400)
      raise ex
    end
  end

end