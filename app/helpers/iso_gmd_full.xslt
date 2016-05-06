<?xml version="1.0"?>
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
      <gmd:MD_Metadata
              xmlns:gco="http://www.isotc211.org/2005/gco"
              xmlns:gmd="http://www.isotc211.org/2005/gmd"
              xmlns:gmi="http://www.isotc211.org/2005/gmi"
              xmlns:xs="http://www.w3.org/2001/XMLSchema"
              xmlns:gmx="http://www.isotc211.org/2005/gmx"
              xmlns:gss="http://www.isotc211.org/2005/gss"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xmlns:gml="http://www.opengis.net/gml/3.2"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              xmlns:eos="http://earthdata.nasa.gov/schema/eos"
              xmlns:srv="http://www.isotc211.org/2005/srv"
              xmlns:gts="http://www.isotc211.org/2005/gts"
              xmlns:swe="http://schemas.opengis.net/sweCommon/2.0/"
              xmlns:gsr="http://www.isotc211.org/2005/gsr">
        <gmd:fileIdentifier>
          <gco:CharacterString>
            <xsl:value-of select="@concept-id"/>
          </gco:CharacterString>
        </gmd:fileIdentifier>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:language"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:characterSet"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:hierarchyLevel"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:contact"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:dateStamp"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:metadataStandardName"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:referenceSystemInfo"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:identificationInfo"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:distributionInfo"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:dataQualityInfo"/>
      </gmd:MD_Metadata>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>