<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <xsl:element name="{$result_root_element}">
      <xsl:if test="$result_root_element = 'csw:GetRecordsResponse'">
        <csw:SearchStatus timestamp="{$server_timestamp}"/>
        <csw:SearchResults numberOfRecordsMatched="{$number_of_records_matched}" numberOfRecordsReturned="{$number_of_records_returned}" nextRecord="{$next_record}" elementSet="{$element_set}" recordSchema="{$record_schema}">
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
      <xsl:copy-of select="*"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>