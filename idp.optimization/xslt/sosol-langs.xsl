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
      <xsl:text>
          </xsl:text>
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="substring(date:date(),1,10)"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>http://papyri.info/editor/users/gabrielbodard</xsl:text>
        </xsl:attribute>
        <xsl:text>rationalized languages in langUsage</xsl:text>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="t:langUsage">

    <xsl:variable name="languages" select="document('sosollangs.xml')"/>
    
    <xsl:copy>
      <xsl:for-each-group select="//*[@xml:lang]" group-by="@xml:lang">
        <xsl:variable name="language" select="@xml:lang"/>
        <xsl:text>
            </xsl:text>
        <xsl:element name="language">
              <xsl:attribute name="ident">
                <xsl:value-of select="@xml:lang"/>
              </xsl:attribute>
              <xsl:value-of select="$languages//language[@ident=$language]"/>
            </xsl:element>
      </xsl:for-each-group>
      <xsl:text>
         </xsl:text>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
