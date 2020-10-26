<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.1">

<xsl:output method="xml" indent="yes" encoding="UTF-8" />

<xsl:key name="index" match="name" use="translate(normalize-space(.), ' ', '')" />
<xsl:key name="regindex" match="name" use="concat(translate(normalize-space(.), ' ', ''),@reg)" />
<xsl:key name="typeindex" match="name" use="concat(translate(normalize-space(.), ' ', ''),@type)" />

<!-- ============================================================= -->
<!--  MODULE:                                          -->
<!--  VERSION DATE:     2006-01-20                                        -->
<!--  VERSION CONTROL:                                             -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- ORIGINAL CREATION DATE:    2006-01-20                   -->
<!-- PURPOSE:     -->
<!-- CREATED FOR:  CCH  www.kcl.ac.uk/cch                          -->
<!-- CREATED BY:                           -->
<!-- COPYRIGHT:   CCH                                        -->
<!-- ============================================================= -->

<xsl:template match="/">
	<body>		
		<xsl:for-each select="//div[@type='edition']//name[generate-id(.)=generate-id(key('index', translate(normalize-space(.), ' ', ''))[1])]">
			<xsl:sort select="translate(normalize-space(.), ' ', '')" />
			<name>
				<form>
					<xsl:value-of select="translate(normalize-space(.), ' ', '')" />
				</form>
				<reg>
					<xsl:value-of select="@reg" />
				</reg>
				<type>
					<xsl:value-of select="@type" />
				</type>
				<count>
					<xsl:value-of select="count(key('index', translate(normalize-space(.), ' ', '')))" />
				</count>
				<allregs>
					<xsl:for-each select="//div[@type='edition']//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')][generate-id(.)=generate-id(key('regindex', concat(translate(normalize-space(.), ' ', ''),@reg))[1])]">
						<xsl:value-of select="@reg" />
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</allregs>
				<alltypes>
					<xsl:for-each select="//div[@type='edition']//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')][generate-id(.)=generate-id(key('typeindex', concat(translate(normalize-space(.), ' ', ''),@type))[1])]">
						<xsl:value-of select="@type" />
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</alltypes>
			</name>
		</xsl:for-each>
	</body>
</xsl:template>


<!--    ***********************************************       -->

</xsl:stylesheet>

<!--    ***********************************************       -->
<!--    *************   END OF STYLESHEET  ************       -->
<!--    ***********************************************       -->
