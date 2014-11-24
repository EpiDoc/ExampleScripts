<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:date="http://exslt.org/dates-and-times" version="2.0">

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
  <!-- |||||||||||||||| copy all comments and proc-instrs  |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="//comment()">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="//processing-instruction()">
    <xsl:text>
</xsl:text>
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||     LIST CHANGES     ||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="t:revisionDesc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="//t:gap[@unit='line'][parent::t:ab][not(preceding-sibling::t:*)] or
        //t:gap[@reason='lost'][@unit='line'][parent::t:ab][not(following-sibling::t:*)]
        [not(preceding-sibling::node()[1][local-name()=('lb','handShift','note','milestone')])]">
        <xsl:text>
</xsl:text>
        <xsl:element name="change">
          <xsl:attribute name="when">
            <xsl:value-of select="substring(date:date(),1,10)"/>
          </xsl:attribute>
          <xsl:attribute name="who">
            <xsl:text>GB</xsl:text>
          </xsl:attribute>
          <xsl:text>fixed gaps missing adjacent line-breaks</xsl:text>
        </xsl:element>
        <xsl:text>
</xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="t:gap[@unit='line'][parent::t:ab][not(preceding-sibling::t:*)]">
    <xsl:element name="lb">
      <xsl:attribute name="n">
        <xsl:value-of select="following::t:lb[1]/@n"/>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="gap">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:gap[@reason='lost'][@unit='line'][parent::t:ab][not(following-sibling::t:*)]
    [not(preceding-sibling::node()[1][local-name()=('lb','handShift','note','milestone')])]">
    <xsl:element name="lb">
      <xsl:attribute name="n">
        <xsl:value-of select="preceding::t:lb[1]/@n"/>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="gap">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
