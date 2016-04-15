require "spec_helper"

RSpec.describe "various GetRecords GET and POST requests", :type => :request do

  describe "Correct POST routing scenarios" do
    it "correctly routes a valid GetRecords POST request" do
      VCR.use_cassette 'requests/get_records/gmi/route_test', :decode_compressed_response => true, :record => :once do
        valid_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmd" resultType="results" service="CSW"
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
        post '/', valid_get_records_request_xml
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_records/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordsResponse'
      end
    end
  end

  describe "INVALID GET and POST requests scenarios" do

    it "correctly handles an unsupported GetRecords GET request" do
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetRecords.is_valid" exceptionCode="5002">
    <ExceptionText>GetRecords only supports POST requests</ExceptionText>
  </Exception>
</ExceptionReport>
      eos
      get '/', :request => 'GetRecords', :version => '2.0.2'
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
    end

    it "correctly handles an invalid (bad 'version' attribute) GetRecords POST request" do
      bad_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmd" resultType="results" service="CSW"
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
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetRecords.validate_post_request" exceptionCode="5001">
    <ExceptionText>The CMR CSW GetRecords POST request must contain the 'version=2.0.2' attribute for the 'GetRecords' root element.</ExceptionText>
  </Exception>
</ExceptionReport>
      eos
      post '/', bad_get_records_request_xml
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
    end

    # missing service
    it "correctly handles an invalid (missing 'service' attribute) GetRecords POST request" do
      bad_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmd" resultType="results"
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
      expect(response.body).to eq expected_response_body
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'ExceptionReport'
    end

    # missing both version and service
    it "correctly handles an invalid (missing 'version' and 'service' attributes) GetCapabilities POST request" do
      bad_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmd" resultType="results"
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
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetRecords.validate_post_request" exceptionCode="5001">
    <ExceptionText>The CSW GetRecords POST request must contain the 'service=CSW' attribute for the 'GetRecords' root element.The CMR CSW 'GetRecords' POST request must contain the 'version=2.0.2' attribute for the 'GetRecords' root element.</ExceptionText>
  </Exception>
</ExceptionReport>
      eos
      post '/', bad_get_records_request_xml
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'ExceptionReport'
    end
  end

  describe "various POST requests" do

    it 'correctly reders default RESULTS FULL ISO MENDS data in response to a basic / no-constrains POST request' do
      VCR.use_cassette 'requests/get_records/gmi/ten_records', :decode_compressed_response => true, :record => :once do
        # notice the outputSchema below http://www.isotc211.org/2005/gmi, which is not the GCMD one http://www.isotc211.org/2005/gmd
        # TODO - revisit this once CMR supports ISO 19115 gmd
        no_constraints_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmi" resultType="results" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
    </csw:Query>
</csw:GetRecords>
        eos
        post '/', no_constraints_get_records_request_xml
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_records/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordsResponse'
        # There should be 10 records
        expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                      'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
      end
    end
  end

  it 'correctly reders default HITS ISO MENDS data in response to a basic / no-constrains POST request' do
    skip("Address when implementing support for resultType='results' and resultType='hits'")
    no_constraints_get_records_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetRecords maxRecords="18" outputFormat="application/xml"
    outputSchema="http://www.isotc211.org/2005/gmd" resultType="hits" service="CSW"
    startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
    <csw:Query typeNames="csw:Record">
        <csw:ElementSetName>full</csw:ElementSetName>
    </csw:Query>
</csw:GetRecords>
    eos
    post '/', no_constraints_get_records_request_xml
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_records/index.xml.erb')
    records_xml = Nokogiri::XML(response.body)
    expect(records_xml.root.name).to eq 'GetRecordsResponse'
    # There should be no children
    expect(records_xml.root.xpath('/csw:GetRecordsResponse/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(0)
  end

  it 'correctly handles a CMR failure' do
    skip("Address when implementing more robust error handling.")

  end
end