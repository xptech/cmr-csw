# used by Rails 4 advanced constraint routing lambda (see config/routes.rb)
class RequestPostRouter

  @@CSW_NAMESPACE = "http://www.opengis.net/cat/csw/2.0.2"

  def self.is_get_record_by_id(request_body)
    request_body_string = request_body.read
    # ensure we don't drain the request body with the above read
    request_body.rewind
    Rails.logger.info("RequestPostRouter.is_get_record_by_id request_body:\n #{request_body_string}")
    xml_request_body = Nokogiri::XML(request_body_string)
    return xml_request_body.root.name == 'GetRecordById'
  end

  def self.is_get_records(request_body)
    request_body_string = request_body.read
    # ensure we don't drain the request body with the above read
    request_body.rewind
    Rails.logger.info("RequestPostRouter.is_get_records request_body:\n #{request_body_string}")
    xml_request_body = Nokogiri::XML(request_body_string)
    return xml_request_body.root.name == 'GetRecords'
  end

  # GetCapabilities POST request must be suppored in addition to GET
  def self.is_get_capabilities(request_body)
    request_body_string = request_body.read
    # ensure we don't drain the request body with the above read
    request_body.rewind
    Rails.logger.info("RequestPostRouter.is_get_capabilities request_body:\n #{request_body_string}")
    xml_request_body = Nokogiri::XML(request_body_string)
    return xml_request_body.root.name == 'GetCapabilities'
  end

end