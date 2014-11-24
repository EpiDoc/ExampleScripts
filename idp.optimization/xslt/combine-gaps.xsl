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
    <xsl:variable name="gaps">
      <xsl:for-each select="//t:gap[@quantity]">
      <xsl:if test="(following-sibling::node()[1][self::text()][normalize-space()=''][following-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit]]
        or following-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit]) 
        and not(
        preceding-sibling::node()[1][self::text()][normalize-space()=''][preceding-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit]]
        or preceding-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit])">
        <xsl:text>y</xsl:text>
      </xsl:if>
      </xsl:for-each>
    </xsl:variable>
      
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="contains($gaps, 'y')">
        <xsl:text>
          </xsl:text>
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="substring(date:date(),1,10)"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>http://papyri.info/editor/users/RaffaeleViglianti</xsl:text>
        </xsl:attribute>
        <xsl:text>Merged adjacent gaps of same reason and summed up their @quantity attributes</xsl:text>
      </xsl:element>
      </xsl:if>
      
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  
  <xsl:template match="t:gap[@quantity]">
    <xsl:choose>
      <!-- If it's the first of n adjacent similar gaps; output merged -->
      <xsl:when test="
        (following-sibling::node()[1][self::text()][normalize-space()=''][following-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit]]
        or following-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit]) 
        and not(
        preceding-sibling::node()[1][self::text()][normalize-space()=''][preceding-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit]]
        or preceding-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit])">
       <xsl:element name="gap">
         <xsl:copy-of select="@* except @quantity"/>
         <xsl:attribute name="quantity">
             <xsl:call-template name="recurse_forward">
               <xsl:with-param name="elm" select="."/>
               <xsl:with-param name="reason" select="normalize-space(@reason)"/>
               <xsl:with-param name="unit" select="normalize-space(@unit)"/>
             </xsl:call-template>
         </xsl:attribute>
       </xsl:element>
      </xsl:when>
      <!-- If it has an immediately preceding similar gap, skip -->
      <xsl:when test="
        preceding-sibling::node()[1][self::text()][normalize-space()=''][preceding-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit]]
        or preceding-sibling::node()[1][self::t:gap][@quantity][@reason = current()/@reason][@unit = current()/@unit]"/>
      <xsl:otherwise>
        <xsl:element name="{local-name()}" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="recurse_forward">
    <xsl:param name="elm"/>
    <xsl:param name="reason"/>
    <xsl:param name="unit"/>
    <xsl:param name="total" select="0"/>
    
    <xsl:choose>
      <xsl:when test="$elm[self::t:gap[@quantity]][normalize-space(@reason)=$reason and normalize-space(@unit)=$unit]">
        <xsl:call-template name="recurse_forward">
          <xsl:with-param name="elm" select="$elm//following-sibling::*[1]"/>
          <xsl:with-param name="reason" select="$reason"/>
          <xsl:with-param name="unit" select="$unit"/>
          <xsl:with-param name="total" select="number($total)+number($elm/@quantity)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$total"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

</xsl:stylesheet>
