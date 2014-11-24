<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- copy all elements and attributes -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- copy comments -->
  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- ||||||||||||||||||||||   names  ||||||||||||||||||||||||| -->

  <xsl:template match="//div[@type='edition']//name">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <!-- TEST FOR ABSENCE OF EXISTING ATT.REG -->
      <xsl:if test="not(string(translate(@nymRef, ' ', '')))">
        <xsl:choose>
          <xsl:when test="ancestor-or-self::*[@xml:lang][1][@xml:lang='grc']">
            <xsl:if
              test="document('../../../00_preprocess/xml/Greek_names.xml')//name[form=translate(normalize-space(current()), ' ', '')][string(translate(reg, ' ', ''))]">
              <xsl:attribute name="reg">
                <xsl:value-of
                  select="document('../../../00_preprocess/xml/Greek_names.xml')//name[form=translate(normalize-space(current()), ' ', '')]/reg"
                />
              </xsl:attribute>
            </xsl:if>
          </xsl:when>
          <xsl:when test="ancestor-or-self::*[@xml:lang][1][@xml:lang='la']">
            <xsl:if
              test="document('../../../00_preprocess/xml/Latin_names.xml')//name[form=translate(normalize-space(current()), ' ', '')][string(translate(reg, ' ', ''))]">
              <xsl:attribute name="reg">
                <xsl:value-of
                  select="document('../../../00_preprocess/xml/Latin_names.xml')//name[form=translate(normalize-space(current()), ' ', '')]/reg"
                />
              </xsl:attribute>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <!-- TEST FOR ABSENSE OF EXISTING ATT.TYPE -->
      <xsl:if test="not(string(translate(@type, ' ', '')))">
        <xsl:choose>
          <xsl:when test="ancestor-or-self::*[@xml:lang][1][@xml:lang='grc']">
            <xsl:if
              test="document('../../../00_preprocess/xml/Greek_names.xml')//name[form=translate(normalize-space(current()), ' ', '')][string(translate(type, ' ', ''))]">
              <xsl:attribute name="type">
                <xsl:value-of
                  select="document('../../../00_preprocess/xml/Greek_names.xml')//name[form=translate(normalize-space(current()), ' ', '')]/type"
                />
              </xsl:attribute>
            </xsl:if>
          </xsl:when>
          <xsl:when test="ancestor-or-self::*[@xml:lang][1][@xml:lang='la']">
            <xsl:if
              test="document('../../../00_preprocess/xml/Latin_names.xml')//name[form=translate(normalize-space(current()), ' ', '')][string(translate(type, ' ', ''))]">
              <xsl:attribute name="type">
                <xsl:value-of
                  select="document('../../../00_preprocess/xml/Latin_names.xml')//name[form=translate(normalize-space(current()), ' ', '')]/type"
                />
              </xsl:attribute>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||   placenames  ||||||||||||||||||||||||| -->

  <xsl:template match="//div[@type='edition']//placeName">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <!-- TEST FOR ABSENCE OF EXISTING ATT.REG -->
      <xsl:if test="not(string(translate(@nymRef, ' ', '')))">
        <xsl:choose>
          <xsl:when test="ancestor-or-self::*[@xml:lang][1][@xml:lang='grc']">
            <xsl:if
              test="document('../../../00_preprocess/xml/Greek_places.xml')//name[form=translate(normalize-space(current()), ' ', '')][string(translate(reg, ' ', ''))]">
              <xsl:attribute name="reg">
                <xsl:value-of
                  select="document('../../../00_preprocess/xml/Greek_places.xml')//name[form=translate(normalize-space(current()), ' ', '')]/reg"
                />
              </xsl:attribute>
            </xsl:if>
          </xsl:when>
          <xsl:when test="ancestor-or-self::*[@xml:lang][1][@xml:lang='la']">
            <xsl:if
              test="document('../../../00_preprocess/xml/Latin_places.xml')//name[form=translate(normalize-space(current()), ' ', '')][string(translate(reg, ' ', ''))]">
              <xsl:attribute name="reg">
                <xsl:value-of
                  select="document('../../../00_preprocess/xml/Latin_places.xml')//name[form=translate(normalize-space(current()), ' ', '')]/reg"
                />
              </xsl:attribute>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <!-- TEST FOR ABSENCE OF EXISTING ATT.TYPE -->
      <xsl:if test="not(string(translate(@type, ' ', '')))">
        <xsl:choose>
          <xsl:when test="ancestor-or-self::*[@xml:lang][1][@xml:lang='grc']">
            <xsl:if
              test="document('../../../00_preprocess/xml/Greek_places.xml')//name[form=translate(normalize-space(current()), ' ', '')][string(translate(type, ' ', ''))]">
              <xsl:attribute name="type">
                <xsl:value-of
                  select="document('../../../00_preprocess/xml/Greek_places.xml')//name[form=translate(normalize-space(current()), ' ', '')]/type"
                />
              </xsl:attribute>
            </xsl:if>
          </xsl:when>
          <xsl:when test="ancestor-or-self::*[@xml:lang][1][@xml:lang='la']">
            <xsl:if
              test="document('../../../00_preprocess/xml/Latin_places.xml')//name[form=translate(normalize-space(current()), ' ', '')][string(translate(type, ' ', ''))]">
              <xsl:attribute name="type">
                <xsl:value-of
                  select="document('../../../00_preprocess/xml/Latin_places.xml')//name[form=translate(normalize-space(current()), ' ', '')]/type"
                />
              </xsl:attribute>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
