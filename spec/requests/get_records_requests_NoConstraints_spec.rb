require "spec_helper"

RSpec.describe "various GetRecords POST requests with NO CONSTRAINTS", :type => :request do

  it 'correctly renders default RESULTS FULL ISO MENDS data in response to a basic / no-constrains POST request' do
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

  #TODO
  it 'correctly renders default RESULTS SUMMARY ISO MENDS data in response to a basic / no-constrains POST request' do
    skip("Address this example when implementing support for ElementSetName SUMMARY resultType='results'")
  end

  #TODO
  it 'correctly renders default RESULTS BRIEF ISO MENDS data in response to a basic / no-constrains POST request' do
    skip("Address this example when implementing support for ElementSetName BRIEF resultType='results'")
  end

  it 'correctly renders default HITS ISO MENDS data in response to a basic / no-constrains POST request' do
    skip("Address this example when implementing support for resultType='results' and resultType='hits'")
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
end

