require 'spec_helper'

RSpec.describe OwsException do
  describe 'OWS Exception' do

    it 'generates a CSW/OWS compliant XML representation' do
      expected_xml_exception = <<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="locator" exceptionCode="code">
    <ExceptionText>message</ExceptionText>
  </Exception>
</ExceptionReport>
        eos

        ex = OwsException.new("code", "message", "locator", 500)
        ex_to_xml = ex.to_xml
        expect(ex_to_xml).to eq expected_xml_exception
    end
  end
end
