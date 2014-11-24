<?xml version="1.0"?>

<!-- ||||||||||||||||||||||||||||||||||||||||||| -->
<!-- |||||  Gabriel BODARD 2009-06-21    |||||| -->
<!-- ||||           Last update 2009-07-11       |||||| -->
<!-- ||||||||||||||||||||||||||||||||||||||||||| -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fmp="http://www.filemaker.com/fmpxmlresult">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"
    doctype-system="http://www.stoa.org/epidoc/dtd/6/tei-epidoc.dtd"/>

  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||  copy all existing elements ||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||| copy all comments  |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||     EXCEPTIONS      |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="titleStmt/title[not(string(@n))]">
    <xsl:variable name="hgvnodump" select="document('../hgvdump/hgvno4ddbonly.xml')//fmp:RESULTSET" as="element()"/>
    <xsl:variable name="perseusno" select="ancestor::TEI.2/@n"/>

    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name() = 'n')]"/>
      <xsl:if test="$hgvnodump//fmp:ROW[fmp:COL[1]/fmp:DATA  = $perseusno]">
        <xsl:attribute name="n">
          <xsl:value-of select="$hgvnodump//fmp:ROW[fmp:COL[1]/fmp:DATA = $perseusno]/fmp:COL[2]/fmp:DATA"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
