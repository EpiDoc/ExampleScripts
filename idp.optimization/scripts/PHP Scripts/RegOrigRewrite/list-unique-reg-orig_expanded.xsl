<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" />
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jul 20, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira and kfl</xd:p>
      <xd:p />
    </xd:desc>
  </xd:doc>
    
    <xsl:template match="files">
    <choices>
      <xsl:apply-templates />
    </choices>
    </xsl:template>  
  
  
  <xsl:template match="tei:choice[ancestor::tei:*[@xml:lang][1][@xml:lang='grc']]/tei:orig">
    <orig>
      <xsl:value-of select="normalize-space(.)" />
    </orig>
  </xsl:template>
  
  <xsl:template match="tei:choice[ancestor::tei:*[@xml:lang][1][@xml:lang='grc']]/tei:orig" mode="all">@<xsl:copy-of select="." />   
  </xsl:template>
  
  <xsl:template match="tei:choice[ancestor::tei:*[@xml:lang][1][@xml:lang='grc']]/tei:reg" mode="all">@<xsl:copy-of select="." />    
  </xsl:template>
  
  <xsl:template match="tei:choice[ancestor::tei:*[@xml:lang][1][@xml:lang='grc']]/tei:reg">
    <reg>
      <xsl:value-of select="normalize-space(.)" />
    </reg>
  </xsl:template>  

  <xsl:template match="node()">
    <xsl:apply-templates />
  </xsl:template>
  


  <xsl:template match="tei:choice[ancestor::tei:*[@xml:lang][1][@xml:lang='grc']][tei:reg or tei:orig]">
    <xsl:variable name="origs">
      <origs>
        <xsl:apply-templates />
      </origs>
    </xsl:variable>
  
    
    <xsl:for-each-group group-by="." select="$origs//orig">
      <xsl:value-of select="current-grouping-key()" />
      <xsl:text>@</xsl:text>
    </xsl:for-each-group>

    <xsl:variable name="regs">
      <regs>
        <xsl:apply-templates />
      </regs>
    </xsl:variable>
  
    
    <xsl:for-each-group group-by="." select="$regs//reg">
      <xsl:value-of select="current-grouping-key()" />
    </xsl:for-each-group>
    
    <xsl:apply-templates select="@*|node()" mode="all" />      
    <xsl:text>@@
</xsl:text>  
    
    
  </xsl:template>
  
</xsl:stylesheet>
