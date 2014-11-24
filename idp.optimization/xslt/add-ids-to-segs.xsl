<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0" 
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
  <!-- |||||||||||||||| copy processing instruction  |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="//processing-instruction()">
    <xsl:text>
</xsl:text>
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
    <xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||| copy all comments  |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="comment()">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

    <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="t:seg[@type='ContentItem']">
    <xsl:copy>
      <xsl:copy-of select="@*[not(name()='xml:id')]"/>
      <xsl:attribute name="xml:id">
        <xsl:value-of select="ancestor::t:text/@xml:id"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="ancestor::t:div[2]/@xml:id"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="ancestor::t:div[1]/@xml:id"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="ancestor::t:ab/@xml:id"/>
        <xsl:text>_ci</xsl:text>
        <xsl:number count="//t:seg[@type='ContentItem']" from="t:ab"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:seg[@type=('narrative','statement')]">
    <xsl:copy>
      <xsl:copy-of select="@*[not(name()='xml:id')]"/>
      <xsl:attribute name="xml:id">
        <xsl:value-of select="ancestor::t:text/@xml:id"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="ancestor::t:div[2]/@xml:id"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="ancestor::t:div[1]/@xml:id"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="ancestor::t:ab/@xml:id"/>
        <xsl:text>_ci</xsl:text>
        <xsl:for-each select="ancestor::t:seg[@type='ContentItem']">
          <xsl:number count="//t:seg[@type='ContentItem']" from="t:ab"/>
        </xsl:for-each>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="substring(@type,1,1)"/>
        <xsl:number value="count(preceding-sibling::t:seg[@type=current()/@type])+1"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
