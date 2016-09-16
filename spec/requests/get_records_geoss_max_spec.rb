require 'spec_helper'

RSpec.describe 'GetRecords GEOSS max records functionality', :type => :request do

  it 'correctly renders 2000 GEOSS records in CSW format' do
    VCR.use_cassette 'requests/get_records/gmi/geoss_max', :decode_compressed_response => true, :record => :once do
      request_xml = <<-eos
<csw:GetRecords maxRecords="2000" outputFormat="application/xml"
      outputSchema="http://www.isotc211.org/2005/gmd" resultType="results" service="CSW"
      startPosition="1" version="2.0.2" xmlns="http://www.opengis.net/cat/csw/2.0.2"
      xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gmd="http://www.isotc211.org/2005/gmd"
      xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc"
      xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
      <csw:Query typeNames="csw:Record">
          <csw:ElementSetName>full</csw:ElementSetName>
          <csw:Constraint version="1.1.0">
              <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                      <ogc:PropertyIsLike>
                          <ogc:PropertyName>IsGeoss</ogc:PropertyName>
                          <ogc:Literal>true</ogc:Literal>
                      </ogc:PropertyIsLike>
              </ogc:Filter>
          </csw:Constraint>
      </csw:Query>
  </csw:GetRecords>
      eos
      post '/collections', request_xml
      expect(response).to have_http_status(:success)
      expect(response).to render_template('get_records/index.xml.erb')
    end
  end

end

