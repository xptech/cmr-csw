require 'spec_helper'

RSpec.describe 'various GetRecords GET and POST requests for request validation and routing verification', :type => :request do

  describe 'Correct POST routing scenarios' do
    it 'correctly routes a valid GetRecords POST request' do
      VCR.use_cassette 'requests/get_records/gmi/route_test', :decode_compressed_response => true, :record => :once do
        valid_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:And>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>ScienceKeywords</ogc:PropertyName>
                        <ogc:Literal>CWIC</ogc:Literal>
                    </ogc:PropertyIsLike>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?\" wildCard="*\">
                        <ogc:PropertyName>Location</ogc:PropertyName>
                        <ogc:Literal>*BRAZIL*</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
        eos
        post '/', valid_get_records_request_xml
        records_xml = Nokogiri::XML(response.body)
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_records/index.xml.erb')

        expect(records_xml.root.name).to eq 'GetRecordsResponse'
      end
    end
  end

  describe 'INVALID GET and POST requests scenarios' do
    it 'correctly handles an unsupported GetRecords GET request' do
      get '/', :request => 'GetRecords', :version => '2.0.2'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('method')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq('Only the POST method is supported for GetRecords')
    end

    it "correctly handles an invalid (bad 'version' attribute) GetRecords POST request" do
      bad_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2_BAD_BAD" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:And>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>CWIC</ogc:Literal>
                    </ogc:PropertyIsLike>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?\" wildCard="*\">
                        <ogc:PropertyName>Location</ogc:PropertyName>
                        <ogc:Literal>*BRAZIL*</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/', bad_get_records_request_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('version')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq('version \'2.0.2_BAD_BAD\' is not supported. Supported version is \'2.0.2\'')
    end

    # missing service
    it "correctly handles an invalid (missing 'service' attribute) GetRecords POST request" do
      bad_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:And>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>CWIC</ogc:Literal>
                    </ogc:PropertyIsLike>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?\" wildCard="*\">
                        <ogc:PropertyName>Location</ogc:PropertyName>
                        <ogc:Literal>*BRAZIL*</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetRecords.validate_post_request" exceptionCode="5001">
    <ExceptionText>The CSW GetRecords POST request must contain the 'service=CSW' attribute for the 'GetRecords' root element.</ExceptionText>
  </Exception>
</ExceptionReport>
      eos
      post '/', bad_get_records_request_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('service')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq('service \'\' is not supported. Supported service is \'CSW\'')
    end

    # missing both version and service
    it "correctly handles an invalid (missing 'version' and 'service' attributes) GetCapabilities POST request" do
      bad_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results"
    startPosition="1" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
        <csw:Constraint version="1.1.0" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
            <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                <ogc:And>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?" wildCard="*">
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>CWIC</ogc:Literal>
                    </ogc:PropertyIsLike>
                    <ogc:PropertyIsLike escapeChar="\\" singleChar="?\" wildCard="*\">
                        <ogc:PropertyName>Location</ogc:PropertyName>
                        <ogc:Literal>*BRAZIL*</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      post '/', bad_get_records_request_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(2)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('version')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('version \'\' is not supported. Supported version is \'2.0.2\'')

      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('service')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('service \'\' is not supported. Supported service is \'CSW\'')

    end
  end

  describe "various error cases" do
    it 'correctly handles a CMR failure' do
      skip("Address this example when implementing more robust error handling.")
    end
  end
end

