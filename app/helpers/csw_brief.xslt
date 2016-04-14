<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <csw:GetRecordByIdResponse>
      <xsl:for-each select="results/result">
        <BriefRecord
                xmlns="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:ows="http://www.opengis.net/ows"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2
                        ../../../csw/2.0.2/record.xsd">

          <dc:identifier>
            <xsl:value-of select="@concept-id"/>
          </dc:identifier>
          <dc:title>
            <xsl:value-of select="gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString"/>
          </dc:title>
          <dc:type>dataset</dc:type>
          <ows:WGS84BoundingBox>
            <ows:LowerCorner>
              <xsl:value-of
                      select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal"/>
              <xsl:text> </xsl:text>
              <xsl:value-of
                      select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal"/>
            </ows:LowerCorner>
            <ows:UpperCorner>
              <xsl:value-of
                      select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal"/>
              <xsl:text> </xsl:text>
              <xsl:value-of
                      select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal"/>
            </ows:UpperCorner>
          </ows:WGS84BoundingBox>
        </BriefRecord>
      </xsl:for-each>
    </csw:GetRecordByIdResponse>

  </xsl:template>

</xsl:stylesheet>