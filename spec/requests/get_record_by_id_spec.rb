require 'spec_helper'

RSpec.describe 'Get Record By ID http GET specs', :type => :request do
  describe 'GET GetRecordById using ISO GMI' do
    it 'correctly renders single ISO GMI record as full' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
        get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'C1224520098-NOAA_NCEI', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'full'
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
      end
    end
    it 'correctly renders two ISO GMI records as full' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/two_records', :decode_compressed_response => true, :record => :once do
        get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'C1224520098-NOAA_NCEI,C1224520058-NOAA_NCEI', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'full'
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(2)
      end
    end
  end
  it 'correctly renders zero ISO GMI records when unknown concept id is supplied' do
    VCR.use_cassette 'requests/get_record_by_id/gmi/no_record', :decode_compressed_response => true, :record => :once do
      get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'foo', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'full'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_record_by_id/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
      # There should be no children
      expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(0)
    end
  end

  it 'correctly reports an error when no id parameter is present' do
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="id" exceptionCode="MissingParameterValue">
    <ExceptionText>id can't be blank</ExceptionText>
  </Exception>
</ExceptionReport>
eos

    get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'full'
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
  end

  it 'correctly reports an error when an incorrect version is requested' do
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="version" exceptionCode="InvalidParameterValue">
    <ExceptionText>version '2.0.x' is not supported. Supported version is '2.0.2'</ExceptionText>
  </Exception>
</ExceptionReport>
    eos

    get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.x', :id => 'foo', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'full'
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
  end
  it 'correctly reports an error when an incorrect service is requested' do
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="service" exceptionCode="InvalidParameterValue">
    <ExceptionText>service 'foo' is not supported. Supported service is 'CSW'</ExceptionText>
  </Exception>
</ExceptionReport>
    eos

    get '/', :service => 'foo', :request => 'GetRecordById', :version => '2.0.2', :id => 'foo', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'full'
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
  end
end