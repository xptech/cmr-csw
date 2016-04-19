require 'spec_helper'

RSpec.describe OgcFilter do
  describe 'OGC Filter Tests' do
    it 'is possible to extract the AnyText element and value from a GetRecords POST XML request' do
      keyword_only_constraint_get_records_request_xml = <<-eos
<csw:GetRecords maxRecords="10" outputFormat="application/xml"
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
                        <ogc:Literal>MODIS</ogc:Literal>
                    </ogc:PropertyIsLike>
                </ogc:And>
            </ogc:Filter>
        </csw:Constraint>
    </csw:Query>
</csw:GetRecords>
      eos
      request_body_xml = Nokogiri::XML(keyword_only_constraint_get_records_request_xml)
      filter = request_body_xml.at_xpath("//csw:GetRecords//csw:Query//csw:Constraint//ogc:Filter",
                                         'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                         'ogc' => 'http://www.opengis.net/ogc')
      expect(filter).not_to eq nil
      cmr_query_params = Hash.new
      helper = OgcFilter.new(filter, cmr_query_params)
      helper.process_any_text
      expect(cmr_query_params['keyword']).to eq('MODIS')
    end

    it 'is possible to extract the TempExtent_begin element and value from a GetRecords POST XML request' do
      skip("Address this example when implementing support for temporal query parameters")
    end

    it 'is possible to extract the TempExtent_end element and value from a GetRecords POST XML request' do
      skip("Address this example when implementing support for temporal query parameters")
    end
  end

  it "is possible to transform XML with nokogiri" do
    stylesheet = <<-eos
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
    exclude-result-prefixes="xs"
    version="2.0">
        <xsl:template match="/">
           <xsl:element name="{$result_root_element}">
            <xsl:if test="$result_root_element = 'csw:GetRecordsResponse'">
              <xsl:element name="TEST"/>
            </xsl:if>
           </xsl:element>
        </xsl:template>
</xsl:stylesheet>
    eos
  xml = <<-eos
<a>
  <b>ElementB</b>
</a>
    eos

    template = Nokogiri::XSLT(stylesheet)
    document = Nokogiri::XML(xml)
    result_root_element = 'csw:GetRecordsResponse'
    transformed_xml_doc = template.transform(document, Nokogiri::XSLT.quote_params(['result_root_element', result_root_element], ))
    expect(transformed_xml_doc.root.name).to eq('GetRecordsResponse')
  end

end