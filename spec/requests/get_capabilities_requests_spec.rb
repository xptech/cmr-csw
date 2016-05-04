require 'spec_helper'
require 'open-uri'

RSpec.describe 'various GetCapabilities GET and POST requests', :type => :request do

  describe 'SUCCESS GET and POST routing scenarios' do

    it 'correctly routes a valid GetCapabilities GET request' do
      get '/', :request => 'GetCapabilities', :service => 'CSW', :version => '2.0.2'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_capabilities/index.xml.erb')
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'Capabilities'
    end

    it 'correctly routes a valid GetCapabilities POST request' do
      VCR.use_cassette 'requests/get_capabilities/schema_validation', :decode_compressed_response => true, :record => :once do
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

      xsd = Nokogiri::XML::Schema(File.read('spec/fixtures/requests/get_capabilities/CSW-discovery.xsd')) do |config|
        config.nonet
      end
      error_message = ''
       # This takes 8 seconds to complete???!!
      xsd.validate(capabilities_xml).each do |error|
        error_message.concat ("#{error.message} \n")
      end
      fail error_message unless error_message.blank?
        end
    end

    # CSW requests with NO parameters are routed to root
    # TODO might want to modify that and have it work via the OwsException
    it 'correctly routes an INVALID CSW GET request' do
      get '/'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('welcome/index')
    end
  end

  describe 'INVALID GET and POST requests scenarios' do

    it "correctly handles an invalid (bad 'service' value) GetCapabilities GET request" do
      get '/', :request => 'GetCapabilities', :service => 'CSW_BAD', :version => '2.0.2'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('service')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("service 'CSW_BAD' is not supported. Supported service is 'CSW'")
    end

    it "correctly handles an invalid (bad 'version' value) GetCapabilities GET request" do
      get '/', :request => 'GetCapabilities', :service => 'CSW', :version => '2.0.BAD'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('version')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("version '2.0.BAD' is not supported. Supported version is '2.0.2'")
    end

    it "correctly handles an invalid (bad 'service' and 'version' value) GetCapabilities GET request" do
      get '/', :request => 'GetCapabilities', :service => 'CSW_BAD', :version => '2.0.BAD'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(2)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('version')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq("version '2.0.BAD' is not supported. Supported version is '2.0.2'")
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('service')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq("service 'CSW_BAD' is not supported. Supported service is 'CSW'")
    end

    it "correctly handles an invalid (missing 'version' value) GetCapabilities GET request" do
      get '/', :request => 'GetCapabilities', :service => 'CSW'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('version')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('MissingParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("version can't be blank")
    end

    it "correctly handles an invalid (missing 'service' value) GetCapabilities GET request" do
      get '/', :request => 'GetCapabilities', :version => '2.0.2'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('service')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('MissingParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("service can't be blank")
    end

    it "correctly handles an invalid (missing 'service' and 'version' values) GetCapabilities GET request" do
      get '/', :request => 'GetCapabilities'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(2)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('version')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('MissingParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq("version can't be blank")
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('service')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('MissingParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq("service can't be blank")
    end

    it "correctly handles an invalid (bad 'service' attribute) GetCapabilities POST request" do
      bad_get_capabilities_request_xml = <<-eos
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
      post '/', bad_get_capabilities_request_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('service')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("service 'CSW_BAD' is not supported. Supported service is 'CSW'")

    end
  end

  it "correctly handles an invalid (bad 'version' attribute) GetCapabilities POST request" do
    bad_get_capabilities_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows" xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc" xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/" xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd" service="CSW" version="2.0.BAD">
</csw:GetCapabilities>
    eos
    post '/', bad_get_capabilities_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('version')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("version '2.0.BAD' is not supported. Supported version is '2.0.2'")

  end

  # missing service
  it "correctly handles an invalid (missing 'service' attribute) GetCapabilities POST request" do
    bad_get_capabilities_request_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<csw:GetCapabilities xmlns:ows="http://www.opengis.net/ows" xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:gml="http://www.opengis.net/gml" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
        xmlns:ogc="http://www.opengis.net/ogc" xmlns:sch="http://www.ascc.net/xml/schematron"
        xmlns:smil20="http://www.w3.org/2001/SMIL20/" xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language"
        xmlns:dct="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 CSW-discovery.xsd" version="2.0.2">
</csw:GetCapabilities>
    eos
    post '/', bad_get_capabilities_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('service')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('MissingParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("service can't be blank")
  end

  # missing version
  it "correctly handles an invalid (missing 'version' attribute) GetCapabilities POST request" do
    bad_get_capabilities_request_xml = <<-eos
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
    post '/', bad_get_capabilities_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('version')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('MissingParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("version can't be blank")

  end

  # missing both version and service
  it "correctly handles an invalid (missing 'version' and 'service' attributes) GetCapabilities POST request" do
    bad_get_capabilities_request_xml = <<-eos
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
    post '/', bad_get_capabilities_request_xml
    expect(response).to have_http_status(:bad_request)
    exception_xml = Nokogiri::XML(response.body)
    expect(exception_xml.root.name).to eq 'ExceptionReport'
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(2)
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('version')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq('MissingParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')[0].text).to eq("version can't be blank")
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('service')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq('MissingParameterValue')
    expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')[1].text).to eq("service can't be blank")

  end
end
