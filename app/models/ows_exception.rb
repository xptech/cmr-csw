# encapsulates a CSW OwsException.  CSW uses the OWS exception specification.
class OwsException < StandardError
  attr_reader :exception_text
  attr_reader :exception_code
  attr_reader :locator
  attr_reader :http_code

  def initialize(exception_code, exception_message, locator, http_code)
    @exception_text = exception_message
    @exception_code = exception_code
    @locator = locator
    @http_code = http_code
    Rails.logger.error("Encountered error: http_code: #{@http_code} exception_text: #{@exception_text} locator: #{@locator} exception_code: #{@exception_code}")
  end

  # XML representation of this exception using the CSW / OWS specification
  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.ExceptionReport('xmlns' => 'http://www.opengis.net/ows', 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
               'xsi:schemaLocation' => 'http://www.opengis.net/ows owsExceptionReport.xsd') {
        xml.Exception('locator'=> @locator, 'exceptionCode' => @exception_code) {
          xml.ExceptionText @exception_text
        }
      }
    end
    return builder.to_xml
  end
end
