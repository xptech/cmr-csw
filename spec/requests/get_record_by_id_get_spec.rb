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
  it 'correctly renders single ISO GMI record as full with output file format application/xml' do
    VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
      get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'C1224520098-NOAA_NCEI', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'full', :outputFormat => 'application/xml'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_record_by_id/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
      expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
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

  it 'correctly reports an error when an incorrect output schema is requested' do
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="outputSchema" exceptionCode="InvalidParameterValue">
    <ExceptionText>Output schema 'foo' is not supported. Supported output schemas are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi</ExceptionText>
  </Exception>
</ExceptionReport>
    eos

    get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'foo', :outputSchema => 'foo', :ElementSetName => 'full'
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
  end

  it 'correctly reports an error when an incorrect element set name is requested' do
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="ElementSetName" exceptionCode="InvalidParameterValue">
    <ExceptionText>Element set name 'foo' is not supported. Supported element set names are brief, summary, full</ExceptionText>
  </Exception>
</ExceptionReport>
    eos

    get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'foo', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'foo'
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
  end
  it 'correctly reports an error when an incorrect output file format' do
    expected_response_body =<<-eos
<?xml version="1.0"?>
<ExceptionReport xmlns="http://www.opengis.net/ows" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/ows owsExceptionReport.xsd">
  <Exception locator="outputFormat" exceptionCode="InvalidParameterValue">
    <ExceptionText>Output file format 'foo' is not supported. Supported output file format is application/xml</ExceptionText>
  </Exception>
</ExceptionReport>
    eos

    get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'foo', :outputSchema => 'http://www.isotc211.org/2005/gmi', :outputFormat => 'foo'
    expect(response).to have_http_status(:bad_request)
    expect(response.body).to eq expected_response_body
  end

  describe 'GET GetRecordById using CSW brief' do
    it 'correctly renders single CSW record as brief' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
        get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'C1224520098-NOAA_NCEI', :outputSchema => 'http://www.opengis.net/cat/csw/2.0.2', :ElementSetName => 'brief'
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
        # The brief record should have an id, title, type and bounding box
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/dc:identifier', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('C1224520098-NOAA_NCEI')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/dc:title', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq("\nGHRSST Level 2P Central Pacific Regional Skin Sea Surface Temperature from the Geostationary Operational Environmental Satellites (GOES) Imager on the GOES-15 satellite (GDS versions 1 and 2)\n")
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/dc:type', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('dataset')

        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/ows:WGS84BoundingBox', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/ows:WGS84BoundingBox/ows:LowerCorner', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').text).to eq('146.0 -44.0')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:BriefRecord/ows:WGS84BoundingBox/ows:UpperCorner', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').text).to eq('-105.0 72.0')
      end
    end
  end

  describe 'GET GetRecordById using ISO GMI brief' do
    it 'correctly renders single CSW record as brief' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
        get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'C1224520098-NOAA_NCEI', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'brief'
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi').size).to eq(1)
        # The brief record should have an id, scope and identification info
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').text).to eq('C1224520098-NOAA_NCEI')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').text).to eq('series')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:identificationInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
      end
    end
  end

  describe 'GET GetRecordById using CSW summary' do
    it 'correctly renders single CSW record as summary' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
        get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'C1224520098-NOAA_NCEI', :outputSchema => 'http://www.opengis.net/cat/csw/2.0.2', :ElementSetName => 'summary'
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
        # The summary record should have an id, title, type and bounding box
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:identifier', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('C1224520098-NOAA_NCEI')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:title', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq("\nGHRSST Level 2P Central Pacific Regional Skin Sea Surface Temperature from the Geostationary Operational Environmental Satellites (GOES) Imager on the GOES-15 satellite (GDS versions 1 and 2)\n")
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:type', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('dataset')

        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/ows:WGS84BoundingBox', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/ows:WGS84BoundingBox/ows:LowerCorner', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').text).to eq('146.0 -44.0')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/ows:WGS84BoundingBox/ows:UpperCorner', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'ows' => 'http://www.opengis.net/ows').text).to eq('-105.0 72.0')
        # And also...  subjects, modified, abstract, spatial
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:subject', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').size).to eq(5)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:subject', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').first.text).to eq('EARTH SCIENCE>OCEANS>OCEAN TEMPERATURE>WATER TEMPERATURE>NONE>NONE>NONE')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dc:modified', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dc' => 'http://purl.org/dc/elements/1.1/').text).to eq('2015-02-18T00:00:00.000Z')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/csw:SummaryRecord/dct:abstract', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'dct' => 'http://purl.org/dc/terms').text).to eq('foo')
      end
    end
  end

  describe 'GET GetRecordById using ISO GMI summary' do
    it 'correctly renders single CSW record as summary' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
        get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'C1224520098-NOAA_NCEI', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'summary'
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi').size).to eq(1)
        # The summary record should have an id, scope and identification info
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').text).to eq('C1224520098-NOAA_NCEI')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').text).to eq('series')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:identificationInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        # And also...
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:distributionInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
      end
    end
  end

  describe 'GET GetRecordById using ISO GMI full' do
    it 'correctly renders single CSW record as full' do
      VCR.use_cassette 'requests/get_record_by_id/gmi/one_record', :decode_compressed_response => true, :record => :once do
        get '/', :service => 'CSW', :request => 'GetRecordById', :version => '2.0.2', :id => 'C1224520098-NOAA_NCEI', :outputSchema => 'http://www.isotc211.org/2005/gmi', :ElementSetName => 'full'
        expect(response).to have_http_status(:success)
        expect(response).to render_template('get_record_by_id/index.xml.erb')
        records_xml = Nokogiri::XML(response.body)
        expect(records_xml.root.name).to eq 'GetRecordByIdResponse'
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi').size).to eq(1)
        # The full record should have everything summary has
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco').text).to eq('C1224520098-NOAA_NCEI')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').text).to eq('series')
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:identificationInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:distributionInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        # And also...
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:language', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:characterSet', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:hierarchyLevel', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:contact', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:dateStamp', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:metadataStandardName', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:referenceSystemInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:identificationInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:distributionInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmd:dataQualityInfo', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
        expect(records_xml.root.xpath('/csw:GetRecordByIdResponse/gmi:MI_Metadata/gmi:acquisitionInformation', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd').size).to eq(1)
      end
    end
  end
end