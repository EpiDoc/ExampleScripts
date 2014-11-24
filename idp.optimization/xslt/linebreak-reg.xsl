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
  <!-- ||||||||||||     LIST CHANGES     ||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="t:revisionDesc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="//text()[following-sibling::node()[1][local-name() = 'lb'][@type='inWord']
        [following-sibling::node()[1][local-name() = 'choice'][child::t:reg]]]">
        <xsl:text>
</xsl:text>
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="substring(date:date(),1,10)"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>GB</xsl:text>
        </xsl:attribute>
        <xsl:text>moved linebreak and missing characters into reg</xsl:text>
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
  
  <xsl:template match="text()[following-sibling::node()[1][local-name() = 'lb'][@type='inWord']
    [following-sibling::node()[1][local-name() = 'choice'][child::t:reg]]]">
    <xsl:for-each select="tokenize(normalize-space(.),'\s+')">
      <xsl:if test="position()!=last()">
        <xsl:value-of select="."/><xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>  
  
  <xsl:template match="t:lb[@type='inWord']
    [preceding-sibling::node()[1][self::text()]]
   [following-sibling::node()[1][local-name()='choice'][child::t:reg]]">
    <xsl:text>
</xsl:text>
  </xsl:template>
  
   <xsl:template match="t:reg[parent::t:choice[preceding-sibling::node()[1][local-name()='lb'][@type='inWord']
     [preceding-sibling::node()[1][self::text()]]]]">
     <xsl:copy>
       <xsl:copy-of select="@*"/>
     <xsl:value-of select="tokenize(normalize-space(preceding::text()[1]),'\s+')[position()=last()]"/>
     <xsl:copy-of select="preceding::t:lb[1]"/>
     <xsl:apply-templates/>
     </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
