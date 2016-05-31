<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <xsl:element name="{$result_root_element}">
      <xsl:if test="$result_root_element = 'csw:GetRecordsResponse'">
        <csw:SearchStatus timestamp="{$server_timestamp}"/>
        <csw:SearchResults numberOfRecordsMatched="{$number_of_records_matched}"
                           numberOfRecordsReturned="{$number_of_records_returned}" nextRecord="{$next_record}"
                           elementSet="{$element_set}" recordSchema="{$record_schema}">
          <xsl:call-template name="entries"/>
        </csw:SearchResults>
      </xsl:if>
      <xsl:if test="$result_root_element = 'csw:GetRecordByIdResponse'">
        <xsl:call-template name="entries"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template name="entries">
    <xsl:for-each select="results/result">
      <csw:Record
              xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
              xmlns:gmd="http://www.isotc211.org/2005/gmd"
              xmlns:gmi="http://www.isotc211.org/2005/gmi"
              xmlns:gml="http://www.opengis.net/gml/3.2"
              xmlns:dc="http://purl.org/dc/elements/1.1/"
              xmlns:dct="http://purl.org/dc/terms/"
              xmlns:ows="http://www.opengis.net/ows"
              xmlns:gco="http://www.isotc211.org/2005/gco"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 record.xsd">
        <dc:identifier>
          <xsl:value-of select="@concept-id"/>
        </dc:identifier>
        <dc:title>
          <xsl:value-of select="gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString"/>
        </dc:title>
        <xsl:if test="gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
          <dc:creator>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/>
          </dc:creator>
        </xsl:if>
        <dc:type>dataset</dc:type>
        <xsl:for-each select="//gmd:keyword">
          <dc:subject>
            <xsl:value-of select="gco:CharacterString"/>
          </dc:subject>
        </xsl:for-each>
        <xsl:if test="gmi:MI_Metadata/gmi:acquisitionInformation/gmi:MI_AcquisitionInformation/gmi:operation/gmi:MI_Operation/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
          <dc:source>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmi:acquisitionInformation/gmi:MI_AcquisitionInformation/gmi:operation/gmi:MI_Operation/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString"/>
          </dc:source>
        </xsl:if>
        <xsl:if test="gmi:MI_Metadata/gmd:language/gco:CharacterString">
          <dc:language>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:language/gco:CharacterString"/>
          </dc:language>
        </xsl:if>
        <xsl:for-each select="//gmd:topicCategory">
          <dc:subject>
            <xsl:value-of select="gmd:MD_TopicCategoryCode"/>
          </dc:subject>
        </xsl:for-each>
        <xsl:if test="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat/gmd:MD_Format/gmd:name">
          <dc:format>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat/gmd:MD_Format/gmd:name/gco:CharacterString"/>
          </dc:format>
        </xsl:if>
        <xsl:for-each
                select="//gmd:aggregationInfo/gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title">
          <dc:relation>
            <xsl:value-of select="gco:CharacterString"/>
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each
                select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date">
          <dct:modified>
            <xsl:value-of select="gco:DateTime"/>
          </dct:modified>
        </xsl:for-each>
        <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString">
          <dct:abstract>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"/>
          </dct:abstract>
        </xsl:if>
        <xsl:for-each
                select="//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints">
          <dct:rights>
            <xsl:value-of
                    select="gmd:MD_RestrictionCode"/>
          </dct:rights>
        </xsl:for-each>
        <xsl:for-each
                select="//gmd:CI_OnlineResource/gmd:linkage">
          <dct:references>
            <xsl:value-of
                    select="gmd:URL"/>
          </dct:references>
        </xsl:for-each>
        <!-- TODO: investigate whether or not there can be multiple polygons for a CMR result -->
        <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon">
          <dct:spatial>gml:Polygon gml:posList
            <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList"/>
          </dct:spatial>
        </xsl:if>
        <!-- TODO: investigate whether or not there can be multiple bounding boxes for a CMR result entry -->
        <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal">
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
        </xsl:if>
      </csw:Record>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>