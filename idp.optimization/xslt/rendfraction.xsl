<?xml version="1.0"?>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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

  <xsl:template match="//comment() | //processing-instruction()">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

<!-- num rend=fraction (in Greek only) -->

<xsl:template match="t:num[contains(@value,'/')][ancestor-or-self::t:*[@xml:lang][1][@xml:lang='grc']][not(@rend)]">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="rend">
      <xsl:text>fraction</xsl:text>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
  
  <!-- language ident=la-Grek (everywhere) -->
  
  <xsl:template match="t:langUsage">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
      <xsl:element name="language">
        <xsl:attribute name="ident">
          <xsl:text>la-Grek</xsl:text>
        </xsl:attribute>
        <xsl:text>Latin in Greek script</xsl:text>
      </xsl:element>
    </xsl:copy>
  </xsl:template>

<!-- find and strip hyphens at end of lines in supplied; add inWord to following lb -->

  <xsl:template match="text()[parent::t:supplied[following-sibling::t:*[1][local-name()='lb']][ends-with(normalize-space(translate(.,' ','')),'-')]]">
    <xsl:value-of select="replace(.,'-','')"/>
  </xsl:template>
  
  <xsl:template match="t:lb[not(@type)]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="preceding-sibling::t:*[1][local-name()='supplied'][ends-with(normalize-space(translate(.,' ','')), '-')]">
        <xsl:attribute name="type">
          <xsl:text>inWord</xsl:text>
        </xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <!-- say what we've done to this file -->
  
  <xsl:template match="t:revisionDesc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="date:date()"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>GB</xsl:text>
        </xsl:attribute>
        <xsl:text>Added language la-Grek</xsl:text>
        <xsl:if test="//t:num[contains(@value,'/')][ancestor-or-self::t:*[@xml:lang][1][@xml:lang='grc']][not(@rend)]">
          <xsl:text>; tagged num rend=fraction</xsl:text>
        </xsl:if>
        <xsl:if test="//text()[parent::t:supplied[following-sibling::t:*[1][local-name()='lb']][ends-with(normalize-space(translate(.,' ','')),'-')]]">
          <xsl:text>; fixed hyphens in supplied</xsl:text>
        </xsl:if>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
