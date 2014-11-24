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
  
  <xsl:template match="unclear[parent::ex]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="note[parent::ex][normalize-space(.) = '?']"/>
 
  <xsl:template match="foreign[parent::ex][normalize-space(.) = '?']"/>

  <xsl:template match="ex[child::unclear or child::note[normalize-space(.) = '?'] or child::foreign[normalize-space(.) = '?']]">
    <xsl:copy>
    <xsl:attribute name="cert">
      <xsl:text>low</xsl:text>
    </xsl:attribute>
    <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
