<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei">
	
	<xsl:template match="tei:TEI" >
		<!-- <xsl:apply-templates select="tei:teiHeader//tei:title" />
		<xsl:apply-templates select="tei:teiHeader//tei:idno[@type='ddb-hybrid']" /> -->
		<xsl:apply-templates select="descendant::tei:text//tei:subst" />
		<xsl:apply-templates select="descendant::tei:text//tei:choice" />	
		<xsl:apply-templates select="descendant::tei:text//tei:app" />
	</xsl:template>
	
	<xsl:variable name="filename" select="tei:TEI//tei:idno[@type='ddb-hybrid']" />
	
	<xsl:output method="xml" omit-xml-declaration='yes' />
	
	<xsl:template match="text()" mode="sub"/>
	
<!--	
	<xsl:template match="tei:teiHeader//tei:title">
		<tei:title><xsl:value-of select="."/></tei:title>
	</xsl:template>

	<xsl:template match="tei:teiHeader//tei:idno[@type='ddb-hybrid']">
		[<xsl:value-of select="."/>]
	</xsl:template>
-->	


	<xsl:template match="tei:subst">
		<xsl:choose>
			<xsl:when test="ancestor::tei:choice|tei:app|tei:subst">				
				<!-- <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>	-->		
			</xsl:when>
			<xsl:otherwise>
				<!-- SUBST (lb: <xsl:value-of select="preceding::tei:lb[1]/@n"/>): -->
****
SUBST| <xsl:value-of select="$filename"/> | <xsl:for-each select="ancestor::tei:div[@type='textpart']">
	<xsl:value-of select="@n" />.
</xsl:for-each><xsl:value-of select="preceding::tei:lb[1]/@n"/>|
[SUB-<xsl:apply-templates select="@*|node()" mode="sub" />]
|<xsl:copy><xsl:apply-templates select="@*|node()" mode="text" /></xsl:copy>
				<!-- <xsl:copy><xsl:apply-templates select="@*|node()" mode="sub" /></xsl:copy>
				<xsl:text>					
				</xsl:text> -->			
			</xsl:otherwise>	
		</xsl:choose>
	</xsl:template>    
  
	<xsl:template match="tei:choice">
		<xsl:choose>
			<xsl:when test="ancestor::tei:choice|tei:app|tei:subst">
				<!-- <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy> -->		
			</xsl:when>
			<xsl:otherwise>
****
				<xsl:choose>
					<xsl:when test="child::tei:corr">
CHOICE/CORR | <xsl:value-of select="$filename"/> | <xsl:for-each select="ancestor::tei:div[@type='textpart']">
	<xsl:value-of select="@n" />.
</xsl:for-each><xsl:value-of select="preceding::tei:lb[1]/@n"/> |					
<!-- CHOICE/CORR (lb: <xsl:value-of select="preceding::tei:lb[1]/@n"/>): -->						
					</xsl:when>
					<xsl:when test="child::tei:reg">
CHOICE/REG | <xsl:value-of select="$filename"/> | <xsl:for-each select="ancestor::tei:div[@type='textpart']">
	<xsl:value-of select="@n" />.
</xsl:for-each><xsl:value-of select="preceding::tei:lb[1]/@n"/> |						
<!-- CHOICE/REG (lb: <xsl:value-of select="preceding::tei:lb[1]/@n"/>): -->
					</xsl:when>	
					<xsl:otherwise>
CHOICE | <xsl:value-of select="$filename"/> | <xsl:for-each select="ancestor::tei:div[@type='textpart']">
	<xsl:value-of select="@n" />.
</xsl:for-each><xsl:value-of select="preceding::tei:lb[1]/@n"/> |							
					</xsl:otherwise>
				</xsl:choose>
[CH-<xsl:apply-templates select="@*|node()" mode="sub" />]
|<xsl:copy><xsl:apply-templates select="@*|node()" mode="text" /></xsl:copy>					
				<!-- <xsl:copy><xsl:apply-templates select="@*|node()" mode="sub" /></xsl:copy>
				<xsl:text>					
				</xsl:text> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>      

 
	<xsl:template match="tei:app">
		<xsl:choose>
			<xsl:when test="ancestor::tei:choice|tei:app|tei:subst">
				<!-- <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy> -->			
			</xsl:when>
			<xsl:otherwise>		
****	
APP@<xsl:value-of select="@type" />| <xsl:value-of select="$filename"/>| <xsl:for-each select="ancestor::tei:div[@type='textpart']">
	<xsl:value-of select="@n" />.
</xsl:for-each><xsl:value-of select="preceding::tei:lb[1]/@n"/>|
<!-- APP@<xsl:value-of select="@type" /> (lb: <xsl:value-of select="preceding::tei:lb[1]/@n"/>): -->	
[APP-<xsl:value-of select="@type" />-<xsl:apply-templates select="@*|node()" mode="sub" />]
|<xsl:copy><xsl:apply-templates select="@*|node()" mode="text" /></xsl:copy>	
				<!-- <xsl:copy><xsl:apply-templates select="@*|node()" mode="sub" /></xsl:copy>
				<xsl:text>					
				</xsl:text>		 -->		
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>   

	
	<xsl:template match="tei:app" mode="sub">
[APP-<xsl:value-of select="@type" />-<xsl:apply-templates select="@*|node()" mode="sub" />]
		<!-- <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>			 -->
	</xsl:template> 
	
	<xsl:template match="tei:choice" mode="sub">
[CH-<xsl:apply-templates select="@*|node()" mode="sub" />]
		<!-- <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>	 -->		
	</xsl:template> 	
	
	<xsl:template match="tei:subst" mode="sub">
[SUB-<xsl:apply-templates select="@*|node()" mode="sub" />]	
		<!-- <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>	 -->
	</xsl:template> 
			
	<xsl:template match="tei:choice/tei:reg" mode="sub">
		-REG-<xsl:apply-templates select="@*|node()" mode="sub" />	
	</xsl:template> 
	
	<xsl:template match="tei:choice/tei:orig" mode="sub">
		-ORIG-<xsl:apply-templates select="@*|node()" mode="sub" />	
	</xsl:template> 

	<xsl:template match="tei:choice/tei:corr" mode="sub">
		-CORR-<xsl:apply-templates select="@*|node()" mode="sub" />	
	</xsl:template> 
	
	<xsl:template match="tei:choice/tei:sic" mode="sub">
		-SIC-<xsl:apply-templates select="@*|node()" mode="sub" />	
	</xsl:template> 
	
	<xsl:template match="tei:app/tei:lem" mode="sub">
		-LEM-<xsl:apply-templates select="@*|node()" mode="sub" />	
	</xsl:template> 	
	
	<xsl:template match="tei:app/tei:rdg" mode="sub">
		-RDG-<xsl:apply-templates select="@*|node()" mode="sub" />	
	</xsl:template> 	
	
	<xsl:template match="tei:subst/tei:add" mode="sub">
		-ADD-<xsl:apply-templates select="@*|node()" mode="sub" />	
	</xsl:template> 	
	
	<xsl:template match="tei:subst/tei:del" mode="sub">
		-DEL-<xsl:apply-templates select="@*|node()" mode="sub" />	
	</xsl:template> 

	<xsl:template match="tei:*" mode="text">
		<xsl:copy><xsl:apply-templates select="@*|node()" mode="text" /></xsl:copy>
	</xsl:template> 

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="sub">
		<!-- <xsl:copy> -->
			<xsl:apply-templates select="@*|node()" mode="sub" />
		<!-- </xsl:copy> -->
	</xsl:template>	

	<xsl:template match="@*|node()" mode="text">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>	

</xsl:stylesheet>
