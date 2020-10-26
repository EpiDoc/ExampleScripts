<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>

  <!-- ||||||||||||||||||||||  copy all existing elements, comments  |||||||||||||||| -->

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- ||||||||||||||||||||||   words  ||||||||||||||||||||||||| -->

  <xsl:template match="//div[@type='edition']//w">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="not(string(translate(normalize-space(@lemma), ' ', '')))">
        <xsl:if
          test="document('../../xml/ia-lemmata/Latin_wordsout.xml')//name[translate(normalize-space(form), ' ', '')=translate(normalize-space(current()), ' ', '')][string(translate(normalize-space(lemma), ' ', ''))]">
          <xsl:choose>            <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='la'">
            <xsl:attribute name="lemma">
              <xsl:value-of
                select="translate(normalize-space(document('../../xml/ia-lemmata/Latin_wordsout.xml')//name[translate(normalize-space(form), ' ', '')=translate(normalize-space(current()), ' &#xA;', '')]/lemma), ' ', '')"
              />
            </xsl:attribute>
          </xsl:when>
            <!--<xsl:when test="ancestor-or-self::*[@lang][1]/@lang='grc'">
              <xsl:attribute name="lemma">
                <xsl:value-of
                  select="translate(normalize-space(document('../../xml/lemmata/wordlemmata.xml')//word[translate(normalize-space(token), ' ', '')=translate(normalize-space(current()), ' &#xA;', '')]/lemma), ' ', '')"
                />
              </xsl:attribute>
            </xsl:when>-->
          </xsl:choose>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- name and persname templates moved to insertnameregs.xsl -->

</xsl:stylesheet>
