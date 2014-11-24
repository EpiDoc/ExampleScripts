<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:date="http://exslt.org/dates-and-times" version="2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

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

  <xsl:template match="//processing-instruction()">
    <xsl:processing-instruction name="oxygen ">
      RNGSchema="http://www.stoa.org/epidoc/schema/8/tei-epidoc.rng" type="xml"
    </xsl:processing-instruction>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||     LIST CHANGES     ||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

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
        <xsl:text>changed schema; added xml:space=preserve; indented</xsl:text>
        <xsl:if test="//t:sic[not(parent::t:choice)]">
          <xsl:text>; changed sic to surplus</xsl:text>
        </xsl:if>
        <xsl:if test="//t:note[@lang='en'][.='?']">
          <xsl:text>; added certainty for note</xsl:text>
        </xsl:if>
        <xsl:if test="//t:titleStmt/t:title/@n">
          <xsl:text>; moved title/@n to idno</xsl:text>
        </xsl:if>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="t:div[@type='edition']">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name() = 'space')]"/>
      <xsl:attribute name="xml:space">
        <xsl:text>preserve</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:titleStmt/t:title[@n]">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name() = 'n')]"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:availability">
    <xsl:if test="//t:titleStmt/t:title/@n">
      <xsl:element name="idno">
        <xsl:attribute name="type">
          <xsl:text>HGV</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="//t:titleStmt/t:title/@n"/>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type">
          <xsl:text>TM</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="replace(//t:titleStmt/t:title/@n,'[a-zA-Z]','')"/>
      </xsl:element>
    </xsl:if>
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="t:sic[not(parent::t:choice)]">
    <xsl:element name="surplus">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="t:note[normalize-space(.)='?']">
    <xsl:choose>
      <xsl:when test="parent::t:supplied or parent::t:expan or parent::t:ex or parent::t:corr"/>
      <xsl:when test="parent::t:add or parent::t:del or parent::t:lem or parent::t:rdg or parent::t:sic">
        <xsl:element name="certainty">
          <xsl:attribute name="match">
            <xsl:text>..</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="locus">
            <xsl:text>value</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="t:supplied[child::t:note[normalize-space(.)='?']]
    |t:expan[child::t:note[normalize-space(.)='?']]
    |t:ex[child::t:note[normalize-space(.)='?']]
    |t:corr[child::t:note[normalize-space(.)='?']]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="not(@cert)">
        <xsl:attribute name="cert">
          <xsl:text>low</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
