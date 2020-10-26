<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1">

<xsl:output method="xml" indent="yes" encoding="UTF-8" />

<xsl:key name="index" match="w" use="translate(normalize-space(.), ' ', '')" />
<xsl:key name="regindex" match="w" use="concat(translate(normalize-space(.), ' ', ''),@lemma)" />

<!-- ============================================================= -->

<xsl:include href="../intermed/z_common.xsl"/>

<xsl:template match="/">
	<body>		
		<xsl:for-each select="//div[@type='edition']//w[ancestor::div[@lang='grc']][not(descendant::gap[reason='lost'])][generate-id(.)=generate-id(key('index', translate(normalize-space(.), ' ', ''))[1])]">
			<xsl:sort select="translate(normalize-space(translate(.,$grkb4,$grkafter)), ' ', '')" />
			<word>
			    <xsl:attribute name="n">
				<xsl:number value="position()"/>
			    </xsl:attribute>
				<token>
					<xsl:value-of select="translate(normalize-space(.), ' ', '')" />
				</token>
				<lemma>
					<xsl:value-of select="@lemma" />
				</lemma>
				<count>
					<xsl:value-of select="count(key('index', translate(normalize-space(.), ' ', '')))" />
				</count>
				<!--<ref>
					<xsl:if test="count(key('index', translate(normalize-space(.), ' ', ''))) = 1">
						<xsl:value-of select=""/>
					</xsl:if>
				</ref>-->
				<alllemmata>
					<xsl:for-each select="//div[@type='edition']//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')][generate-id(.)=generate-id(key('regindex', concat(translate(normalize-space(.), ' ', ''),@reg))[1])]">
						<xsl:value-of select="@reg" />
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</alllemmata>
			</word>
		</xsl:for-each>
	</body>
</xsl:template>


<!-- ***********************************************  -->

</xsl:stylesheet>

