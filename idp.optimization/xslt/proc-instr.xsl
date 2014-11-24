<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0" 
  xmlns:date="http://exslt.org/dates-and-times"
  version="2.0">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||  copy all existing elements ||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="t:*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||| copy all comments  |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="//comment()">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  
  <xsl:template match="t:TEI"><!--
    <xsl:text>
</xsl:text>
    <xsl:processing-instruction name="xml-model">
      href="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng"</xsl:processing-instruction>-->
    <xsl:text>
</xsl:text>
    <xsl:processing-instruction name="oxygen">
      RNGSchema="http://www.stoa.org/epidoc/schema/latest/tei-epidoc.rng" type="xml"</xsl:processing-instruction>
    <xsl:text>
</xsl:text>
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
