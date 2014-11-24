<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"
    doctype-system="http://www.stoa.org/epidoc/dtd/6/tei-epidoc.dtd"/>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||  copy all existing elements ||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of
        select="@*[not(local-name()=('default','org','sample','full','status','anchored'))]"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||| copy all comments  |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

<xsl:template match="supplied[@reason='illegible']">
  <xsl:copy>
    <xsl:copy-of select="@*[not(local-name() = 'reason')]"/>
    <xsl:attribute name="reason">
      <xsl:text>undefined</xsl:text>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
