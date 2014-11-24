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
      <xsl:if test="//t:change[not(starts-with(@who,'http://papyri.info/editor/users/'))]">
        <xsl:text>
          </xsl:text>
        <xsl:element name="change">
          <xsl:attribute name="when">
            <xsl:value-of select="substring(date:date(),1,10)"/>
          </xsl:attribute>
          <xsl:attribute name="who">
            <xsl:text>http://papyri.info/editor/users/gabrielbodard</xsl:text>
          </xsl:attribute>
          <xsl:text>changed editor names to URIs</xsl:text>
        </xsl:element>
      </xsl:if>
      <xsl:for-each select="t:change">
        <xsl:sort select="@when" order="descending"/>
        <xsl:text>
          </xsl:text>
        <xsl:copy>
          <xsl:copy-of select="@*[not(local-name()='who')]"/>
          <xsl:attribute name="who">
            <xsl:choose>
              <xsl:when test="starts-with(@who,'http://papyri.info/editor/users/')">
                <xsl:value-of select="@who"/>
              </xsl:when>
              <xsl:when test="document('sosoluns.xml')//name[(normalize-space(.)=normalize-space(current()/@who))]">
                <xsl:value-of select="document('sosoluns.xml')//name[(normalize-space(.)=normalize-space(current()/@who))]/following-sibling::uri[1]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@who"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
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
  
  <!--<xsl:template match="t:language[@ident='grc']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:text>Greek</xsl:text>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:language[@ident='grc-Latn']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:text>Greek in Latin script</xsl:text>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="t:langUsage">
    <xsl:copy>
      <xsl:apply-templates/>
      <xsl:element name="language">
        <xsl:attribute name="ident"><xsl:text>ar</xsl:text></xsl:attribute>
        <xsl:text>Arabic</xsl:text>
      </xsl:element>
      <xsl:text>
            </xsl:text>
      <xsl:element name="language">
        <xsl:attribute name="ident"><xsl:text>egy-Egyd</xsl:text></xsl:attribute>
        <xsl:text>Demotic</xsl:text>
      </xsl:element>
      <xsl:text>
            </xsl:text>
      <xsl:element name="language">
        <xsl:attribute name="ident"><xsl:text>it</xsl:text></xsl:attribute>
        <xsl:text>Italian</xsl:text>
      </xsl:element>
      <xsl:text>
            </xsl:text>
      <xsl:element name="language">
        <xsl:attribute name="ident"><xsl:text>es</xsl:text></xsl:attribute>
        <xsl:text>Spanish</xsl:text>
      </xsl:element>
      <xsl:text>
            </xsl:text>
      <xsl:element name="language">
        <xsl:attribute name="ident"><xsl:text>nl</xsl:text></xsl:attribute>
        <xsl:text>Dutch</xsl:text>
      </xsl:element>
      <xsl:text>
        </xsl:text>
    </xsl:copy>
  </xsl:template>-->
  
</xsl:stylesheet>
