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
    <xsl:if test="not(following-sibling::processing-instruction())">
    <xsl:text>
</xsl:text>
  </xsl:if>
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
  
  <!--<xsl:template match="t:revisionDesc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="//t:div[@type='edition']//t:name[not(string(translate(@nymRef, ' ', '')))][document('../../xml//lemmata/grc-nametable.xml')//word[token=translate(normalize-space(current()), ' ', '')][string(translate(nymRef, ' ', ''))]]">
        <xsl:text>
</xsl:text>
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="substring(date:date(),1,10)"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>GB</xsl:text>
        </xsl:attribute>
        <xsl:text>auto-lemmatized Greek names</xsl:text>
      </xsl:element>
        <xsl:text>
</xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>-->

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="//t:div[@type='edition']//t:name[not(@nymRef)]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
        <!--<xsl:choose>
          <xsl:when test="ancestor-or-self::t:*[@xml:lang][1][@xml:lang='grc']">-->
            <xsl:if
              test="document('../../xmod/webapp/root/xml/tables/grc-nametable.xml')//word[normalize-unicode(token)=normalize-unicode(translate(normalize-space(current()), ' ', ''))][string(translate(nymRef, ' ', ''))]">
              <xsl:attribute name="nymRef">
                <xsl:value-of
                  select="normalize-unicode(document('../../xmod/webapp/root/xml/tables/grc-nametable.xml')//word[normalize-unicode(token)=normalize-unicode(translate(normalize-space(current()), ' ', ''))]/nymRef)"
                />
              </xsl:attribute>
            </xsl:if>
          <!--</xsl:when>
        </xsl:choose>-->
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
