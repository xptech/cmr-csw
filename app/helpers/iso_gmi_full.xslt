<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <csw:GetRecordByIdResponse>
      <xsl:for-each select="results/result">
        <xsl:copy-of select="*"/>
      </xsl:for-each>
    </csw:GetRecordByIdResponse>
  </xsl:template>
</xsl:stylesheet>