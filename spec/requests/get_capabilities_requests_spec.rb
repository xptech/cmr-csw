require "spec_helper"

RSpec.describe "various GetCapabilities GET and POST requests", :type => :request do

  describe "SUCCESS GET and POST routing scenarios" do

    it "correctly routes a valid GetCapabilities GET request" do
      get '/', :request => 'GetCapabilities', :service => 'CSW', :version => '2.0.2'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_capabilities/index.xml.erb')
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'Capabilities'
    end

    it "correctly routes a valid GetCapabilities POST request" do
      valid_get_capabilities_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml"
        xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc"
        xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/"
        xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd" service="CSW" version="2.0.2">
</csw:GetCapabilities>
eos
      post '/', valid_get_capabilities_request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_capabilities/index.xml.erb')
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'Capabilities'
    end

    # CSW requests with NO parameters are routed to root
    # TODO might want to modify that and have it work via the OwsException
    it "correctly routes an INVALID CSW GET request" do
      get '/'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('welcome/index')
    end
  end

  describe "INVALID GET and POST requests scenarios" do

    it "correctly handles an invalid (bad 'service' value) GetCapabilities GET request" do
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CSW GetCapabilities GET request must contain the 'service=CSW' query parameter.</ExceptionText>
  </Exception>
</ExceptionReport>
      eos
      get '/', :request => 'GetCapabilities', :service => 'CSW_BAD', :version => '2.0.2'
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'ExceptionReport'
    end

    it "correctly handles an invalid (bad 'version' value) GetCapabilities GET request" do
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CMR CSW GetCapabilities GET request must contain the 'version=2.0.2' query parameter.</ExceptionText>
  </Exception>
</ExceptionReport>
      eos
      get '/', :request => 'GetCapabilities', :service => 'CSW', :version => '2.0.BAD'
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'ExceptionReport'
    end

    it "correctly handles an invalid (bad 'service' and 'version' value) GetCapabilities GET request" do
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CSW GetCapabilities GET request must contain the 'service=CSW' query parameter.The CMR CSW GetCapabilities GET request must contain the 'version=2.0.2' query parameter.</ExceptionText>
  </Exception>
</ExceptionReport>
      eos
      get '/', :request => 'GetCapabilities', :service => 'CSW_BAD', :version => '2.0.BAD'
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'ExceptionReport'
    end

    it "correctly handles an invalid (missing 'version' value) GetCapabilities GET request" do
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CMR CSW GetCapabilities GET request must contain the 'version=2.0.2' query parameter.</ExceptionText>
  </Exception>
</ExceptionReport>
eos
      get '/', :request => 'GetCapabilities', :service => 'CSW'
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'ExceptionReport'
    end

    it "correctly handles an invalid (missing 'service' value) GetCapabilities GET request" do
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CSW GetCapabilities GET request must contain the 'service=CSW' query parameter.The CMR CSW GetCapabilities GET request must contain the 'version=2.0.2' query parameter.</ExceptionText>
  </Exception>
</ExceptionReport>
      eos
      get '/', :request => 'GetCapabilities', :version => '2.0.BAD'
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'ExceptionReport'
    end

    it "correctly handles an invalid (missing 'service' and 'version' values) GetCapabilities GET request" do
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CSW GetCapabilities GET request must contain the 'service=CSW' query parameter.The CMR CSW GetCapabilities GET request must contain the 'version=2.0.2' query parameter.</ExceptionText>
  </Exception>
</ExceptionReport>
eos
      get '/', :request => 'GetCapabilities'
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'ExceptionReport'
    end

    it "correctly handles an invalid (bad 'service' attribute) GetCapabilities POST request" do
      bad_get_capabilities_request_xml  = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows" xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc" xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/" xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd" service="CSW_BAD" version="2.0.2">
</csw:GetCapabilities>
eos
      expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CSW GetCapabilities POST request must contain the 'service=CSW' attribute for the 'GetCapabilities' root element.</ExceptionText>
  </Exception>
</ExceptionReport>
eos
      post '/', bad_get_capabilities_request_xml
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq expected_response_body
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'ExceptionReport'
    end
  end

  it "correctly handles an invalid (bad 'version' attribute) GetCapabilities POST request" do
    bad_get_capabilities_request_xml  = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows" xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc" xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/" xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd" service="CSW" version="2.0.2_BAD">
</csw:GetCapabilities>
eos
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CMR CSW GetCapabilities POST request must contain the 'version=2.0.2' attribute for the 'GetCapabilities' root element.</ExceptionText>
  </Exception>
</ExceptionReport>
eos
    post '/', bad_get_capabilities_request_xml
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
    capabilities_xml = Nokogiri::XML(response.body)
    expect(capabilities_xml.root.name).to eq 'ExceptionReport'
  end

  # missing service
  it "correctly handles an invalid (missing 'service' attribute) GetCapabilities POST request" do
    bad_get_capabilities_request_xml  = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows" xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc" xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/" xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd" version="2.0.2_BAD">
</csw:GetCapabilities>
eos
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CSW GetCapabilities POST request must contain the 'service=CSW' attribute for the 'GetCapabilities' root element.The CMR CSW GetCapabilities POST request must contain the 'version=2.0.2' attribute for the 'GetCapabilities' root element.</ExceptionText>
  </Exception>
</ExceptionReport>
eos
    post '/', bad_get_capabilities_request_xml
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
    capabilities_xml = Nokogiri::XML(response.body)
    expect(capabilities_xml.root.name).to eq 'ExceptionReport'
  end

  # missing version
  it "correctly handles an invalid (missing 'version' attribute) GetCapabilities POST request" do
    bad_get_capabilities_request_xml  = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows" xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc" xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/" xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd" service="CSW">
</csw:GetCapabilities>
eos
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CMR CSW GetCapabilities POST request must contain the 'version=2.0.2' attribute for the 'GetCapabilities' root element.</ExceptionText>
  </Exception>
</ExceptionReport>
eos
    post '/', bad_get_capabilities_request_xml
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
    capabilities_xml = Nokogiri::XML(response.body)
    expect(capabilities_xml.root.name).to eq 'ExceptionReport'
  end

  # missing both version and service
  it "correctly handles an invalid (missing 'version' and 'service' attributes) GetCapabilities POST request" do
    bad_get_capabilities_request_xml  = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows" xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc" xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/" xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd">
</csw:GetCapabilities>
    eos
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="CMR CSW:GetCapability.is_valid" exceptionCode="100">
    <ExceptionText>The CSW GetCapabilities POST request must contain the 'service=CSW' attribute for the 'GetCapabilities' root element.The CMR CSW GetCapabilities POST request must contain the 'version=2.0.2' attribute for the 'GetCapabilities' root element.</ExceptionText>
  </Exception>
</ExceptionReport>
eos
    post '/', bad_get_capabilities_request_xml
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
    capabilities_xml = Nokogiri::XML(response.body)
    expect(capabilities_xml.root.name).to eq 'ExceptionReport'
  end
end
