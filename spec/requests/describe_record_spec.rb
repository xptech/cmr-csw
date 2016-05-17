require 'spec_helper'

RSpec.describe 'Describe record', :type => :request do
  describe 'Successful describe record' do
    it 'correctly routes a valid DescribeRecord GET request' do
      get '/', :request => 'DescribeRecord', :service => 'CSW', :version => '2.0.2'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      capabilities_xml = Nokogiri::XML(response.body)
      expect(capabilities_xml.root.name).to eq 'DescribeRecordResponse'
    end

    it 'correctly returns the csw schema' do
      get '/', :request => 'DescribeRecord', :service => 'CSW', :version => '2.0.2', :NAMESPACE => 'xmlns(csw=http://www.opengis.net/cat/csw/2.0.2)'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.opengis.net/cat/csw/2.0.2']/xsd:schema[@targetNamespace='http://www.opengis.net/cat/csw']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end

    it 'correctly returns the gmi schema' do
      get '/', :request => 'DescribeRecord', :service => 'CSW', :version => '2.0.2', :NAMESPACE => 'xmlns(gmi=http://www.isotc211.org/2005/gmi)'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end

    it 'correctly returns the gmd schema' do
      get '/', :request => 'DescribeRecord', :service => 'CSW', :version => '2.0.2', :NAMESPACE => 'xmlns(gmd=http://www.isotc211.org/2005/gmd)'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmd']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmd']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmd']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end

    it 'correctly returns the csw and gmi schemas' do
      get '/', :request => 'DescribeRecord', :service => 'CSW', :version => '2.0.2', :NAMESPACE => 'xmlns(csw=http://www.opengis.net/cat/csw/2.0.2),xmlns(gmi=http://www.isotc211.org/2005/gmi)'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('describe_record/index.xml.erb')
      response_xml = Nokogiri::XML(response.body)
      expect(response_xml.root.name).to eq 'DescribeRecordResponse'
      expect(response_xml.root.xpath('/csw:DescribeRecordResponse/csw:SchemaComponent', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(2)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      expect(response_xml.root.xpath("/csw:DescribeRecordResponse/csw:SchemaComponent[@targetNamespace='http://www.isotc211.org/2005/gmi']/xsd:schema[@targetNamespace='http://www.isotc211.org/2005/gmi']", 'xsd' => 'http://www.w3.org/2001/XMLSchema', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
    end
  end
  describe 'Failed describe record' do
    it 'correctly routes a valid DescribeRecord POST request but fails validation' do
      post_xml = <<-eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<DescribeRecord
  service="CSW"
  version="2.0.2"
  outputFormat="application/xml"
  schemaLanguage="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2
                      ../../../csw/2.0.2/CSW-discovery.xsd">
  <TypeName>csw:Record</TypeName>
</DescribeRecord>
      eos
      post '/', post_xml
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('method')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("Method 'POST' method is not supported. Supported methods for DescribeRecord are GET")
    end

    it 'returns an error for an unknown namespace' do
      get '/', :request => 'DescribeRecord', :service => 'CSW', :version => '2.0.2', :NAMESPACE => 'xmlns(csw=http://www.opengis.net/cat/csw/2.0.2x)'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('NAMESPACE')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("Namespace 'http://www.opengis.net/cat/csw/2.0.2x' is not supported. Supported namespaces are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi, http://www.isotc211.org/2005/gmd")
    end

    it 'returns an error for an unknown schema language' do
      get '/', :request => 'DescribeRecord', :service => 'CSW', :version => '2.0.2', :schemaLanguage => 'foo'
      expect(response).to have_http_status(:bad_request)
      exception_xml = Nokogiri::XML(response.body)
      expect(exception_xml.root.name).to eq 'ExceptionReport'
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@locator', 'ows' => 'http://www.opengis.net/ows').text).to eq('schemaLanguage')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/@exceptionCode', 'ows' => 'http://www.opengis.net/ows').text).to eq('InvalidParameterValue')
      expect(exception_xml.root.xpath('/ows:ExceptionReport/ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows').text).to eq("Schema Language 'foo' is not supported. Supported output file format is http://www.w3.org/2001/XMLSchema, XMLSCHEMA")
    end
  end
end

