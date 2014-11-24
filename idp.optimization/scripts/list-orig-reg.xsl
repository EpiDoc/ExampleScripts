<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jul 19, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>Lists all the choice/reg|orig in the source.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:template match="files">
    <choices>
      <xsl:apply-templates />
    </choices>
  </xsl:template>

  <xsl:template match="tei:choice[ancestor::tei:*[@xml:lang][1][@xml:lang='grc']][tei:reg or tei:orig]">
    <choice>
      <xsl:attribute name="n">
        <xsl:value-of select="ancestor::tei:TEI//tei:idno[@type='filename']" />
        <xsl:text>,</xsl:text>
        <xsl:for-each select="ancestor::tei:div[@type='textpart'][@n]">
          <xsl:value-of select="@n" />

          <xsl:if test="position() != last()">
            <xsl:text>.</xsl:text>
          </xsl:if>
        </xsl:for-each>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="preceding::tei:lb[1]/@n" />
      </xsl:attribute>
      <reg n="{tei:reg}">
        <xsl:sequence select="tei:reg" />
      </reg>
      <orig n="{tei:orig}">
        <xsl:sequence select="tei:orig" />
      </orig>
    </choice>
  </xsl:template>

  <xsl:template match="node()">
    <xsl:apply-templates />
  </xsl:template>
</xsl:stylesheet>
