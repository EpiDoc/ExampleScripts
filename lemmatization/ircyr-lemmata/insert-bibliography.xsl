<?xml version="1.0"?>

<!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
<!-- ||||||       XSLT Stylesheet to copy all content in one EpiDoc file      |||||| -->
<!-- ||||||     resp: Gabriel BODARD              last: 2010-01-20                  |||||| -->
<!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <!--  copy elements and attributes -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!--  copy comments  -->
  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- exceptions -->
  <xsl:template match="div[@type='bibliography']">
    <xsl:variable name="currid" select="//TEI.2/@id"/>
    <xsl:choose>
      <xsl:when
        test="document('../../xml/edh/edh-and-irt.xml')//irt = $currid
        or document('../../xml/edh/phi-and-irt.xml')//irt = $currid">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:element name="head">
            <xsl:text>Bibliography</xsl:text>
          </xsl:element>
          <xsl:element name="p">
            <xsl:apply-templates select="p/node()"/>
            <xsl:if test="document('../../xml/edh/edh-and-irt.xml')//irt = $currid">
              <xsl:text> </xsl:text>
              <xsl:element name="bibl">
                <xsl:element name="title">
                  <xsl:text>EDH</xsl:text>
                </xsl:element>
                <xsl:for-each select="document('../../xml/edh/edh-and-irt.xml')//row[irt = $currid]">
                  <xsl:text>, </xsl:text>
                  <xsl:element name="biblScope">
                    <xsl:value-of select="edh"/>
                  </xsl:element>
                </xsl:for-each>
                <xsl:text>. </xsl:text>
              </xsl:element>
            </xsl:if>
            <xsl:if test="document('../../xml/edh/phi-and-irt.xml')//irt = $currid">
              <xsl:text> </xsl:text>
              <xsl:element name="bibl">
                <xsl:element name="title">
                  <xsl:text>PHI</xsl:text>
                </xsl:element>
                <xsl:for-each select="document('../../xml/edh/phi-and-irt.xml')//row[irt = $currid]">
                  <xsl:text>, </xsl:text>
                  <xsl:element name="biblScope">
                    <xsl:value-of select="phi"/>
                  </xsl:element>
                </xsl:for-each>
                <xsl:text>. </xsl:text>
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="revisionDesc">
    <xsl:variable name="currid" select="//TEI.2/@id"/>
        <xsl:copy>
      <xsl:if
        test="document('../../xml/edh/edh-and-irt.xml')//irt = $currid
        or document('../../xml/edh/phi-and-irt.xml')//irt = $currid">
        <xsl:element name="change">
          <xsl:element name="date">
            <xsl:text>2010-01-25</xsl:text>
          </xsl:element>
            <xsl:element name="respStmt">
          <xsl:element name="name">
            <xsl:text>GB</xsl:text>
          </xsl:element>
            </xsl:element>
          <xsl:element name="item">
            <xsl:text>added bibliographical ref to database</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:if>
          <xsl:apply-templates/>
        </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
