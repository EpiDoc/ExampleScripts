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
      <xsl:if test="//t:app[@type=('BL','SoSOL')]">
        <xsl:text>
          </xsl:text>
        <xsl:element name="change">
          <xsl:attribute name="when">
            <xsl:value-of select="substring(date:date(),1,10)"/>
          </xsl:attribute>
          <xsl:attribute name="who">
            <xsl:text>GB</xsl:text>
          </xsl:attribute>
          <xsl:text>converted app type=BL|SoSOL to editorial</xsl:text>
        </xsl:element>
      </xsl:if>
      <xsl:for-each select="t:change">
        <xsl:sort select="@when" order="descending"/>
        <xsl:text>
          </xsl:text>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
      <xsl:text>
      </xsl:text>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="t:app[@type=('BL','SoSOL')]">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()='type')]"/>
      <xsl:attribute name="type">
        <xsl:text>editorial</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="t:app[@type=('BL','SoSOL')]/t:lem">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()='resp')]"/>
      <xsl:attribute name="resp">
        <xsl:choose>
          <xsl:when test="parent::t:app[@type='BL']">
            <xsl:text>BL </xsl:text>
          </xsl:when>
          <xsl:when test="parent::t:app[@type='SoSOL']">
            <xsl:text>PN </xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:value-of select="normalize-space(@resp)"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
