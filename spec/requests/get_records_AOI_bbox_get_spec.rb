require "spec_helper"

RSpec.describe "various successful GetRecords GET requests with BBOX CONSTRAINTS", :type => :request do

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX constraint GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_1', :decode_compressed_response => true, :record => :once do
      get '/collections', :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'BoundingBox=-180.00,-90.00,180.000,90', :CONSTRAINTLANGUAGE => 'CQL_TEXT'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX and AnyText constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_2', :decode_compressed_response => true, :record => :once do
      get '/collections', :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results', :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  # resulting CMR Query is:
  # search/collections?bounding_box=-180.00,-90.00,180.000,90&include_tags=org.ceos.wgiss.cwic.granules.prod&keyword=MODIS&temporal=1990-09-03T00:00:01Z/
  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX AnyText, TempExtent_begin constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_3', :decode_compressed_response => true, :record => :once do
      get '/collections', :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  # resulting query is:
  # search/collections?bounding_box=-180.00,-90.00,180.000,90&include_tags=org.ceos.wgiss.cwic.granules.prod&keyword=MODIS&temporal=/2008-09-06T23:59:59Z
  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX AnyText, TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_4', :decode_compressed_response => true, :record => :once do
      get '/collections', :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
      records_xml = Nokogiri::XML(response.body)
      expect(records_xml.root.name).to eq 'GetRecordsResponse'
      # There should be 10 records
      expect(records_xml.root.xpath('/csw:GetRecordsResponse/csw:SearchResults/gmi:MI_Metadata', 'gmi' => 'http://www.isotc211.org/2005/gmi',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(10)
    end
  end

  it 'correctly renders RESULTS FULL ISO MENDS (gmi) data in response to a basic BBOX AnyText, TempExtent_begin and TempExtent_end constraints GET request' do
    VCR.use_cassette 'requests/get_records/gmi/bbox_5', :decode_compressed_response => true, :record => :once do
      get '/collections', :request => 'GetRecords', :service => 'CSW', :version => '2.0.2', :ElementSetName => 'full',
          :resultType => 'results',
          :constraint => 'BoundingBox=-180.00,-90.00,180.000,90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z',
          :CONSTRAINTLANGUAGE => 'CQL_TEXT'
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
