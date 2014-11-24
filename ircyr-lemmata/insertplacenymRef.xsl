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
  
  <xsl:template match="t:TEI">
    <xsl:text>
</xsl:text>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
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
  <!-- ||||||||||||     LIST CHANGES     ||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="t:revisionDesc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="//t:div[@type='edition']//t:placeName[not(@nymRef)]">
        <xsl:variable name="allpns">
          <xsl:for-each select="//t:div[@type='edition']//t:placeName[not(@nymRef)]">
            <xsl:copy>
              <xsl:value-of select="lower-case(.)"/>
            </xsl:copy>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="document('../../xml/lemmata/placenametable-lemmatized.xml')//word[lower-case(translate(normalize-space(child::token),' ',''))=$allpns//t:placeName and string(translate(normalize-space(child::reg), ' ', ''))]">
        <xsl:text>
         </xsl:text>
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="substring(date:date(),1,10)"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>GB</xsl:text>
        </xsl:attribute>
        <xsl:text>lemmatized Greek placenames</xsl:text>
      </xsl:element>
      </xsl:if>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="//t:div[@type='edition']//t:placeName">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <!-- TEST FOR ABSENCE OF EXISTING @nymRef -->
      <xsl:if test="not(@nymRef)">
        <xsl:variable name="currtok">
          <xsl:value-of select="lower-case(translate(normalize-space(.),' ',''))"/>
        </xsl:variable>
            <xsl:if
              test="document('../../xml/lemmata/placenametable-lemmatized.xml')//word[lower-case(translate(normalize-space(child::token),' ',''))=$currtok][string(translate(normalize-space(child::reg), ' ', ''))]">
              <xsl:attribute name="nymRef">
                <xsl:value-of
                  select="document('../../xml/lemmata/placenametable-lemmatized.xml')//word[lower-case(translate(normalize-space(child::token),' ',''))=$currtok][1]/reg"
                />
              </xsl:attribute>
            </xsl:if>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
