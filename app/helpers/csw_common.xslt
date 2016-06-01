<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:ows="http://www.opengis.net/ows"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="xml" indent="yes"/>
  <!-- Nokogiri only supports xslt 1.0 where functions are not a native construct, must use templates -->
  <!-- functionality in this stylesheet can be used across the csw_brief.xslt, csw_summary.xslt and csw_full.xslt -->

  <!-- TODO: investigate whether or not there can be multiple polygons for a CMR result -->
  <xsl:template name="process_polygon">
    <xsl:param name="current_result"/>
    <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList">
        <dct:spatial>gml:Polygon gml:posList
          <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList"/>
        </dct:spatial>
    </xsl:if>
  </xsl:template>

  <!-- TODO: investigate whether or not there can be multiple points for a CMR result -->
  <xsl:template name="process_point">
    <xsl:param name="current_result"/>
    <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Point/gml:pos">
      <dct:spatial>gml:Point gml:pos
        <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Point/gml:pos"/>
      </dct:spatial>
    </xsl:if>
  </xsl:template>

  <!-- TODO: investigate whether or not there can be multiple bounding boxes for a CMR result entry -->
  <xsl:template name="process_bbox">
    <xsl:param name="current_result"/>
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
  </xsl:template>

</xsl:stylesheet>