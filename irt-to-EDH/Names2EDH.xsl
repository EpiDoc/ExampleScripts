<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- 
        IRT - generates a table of texts formatted with leiden style for edh
        RV 08-07-2009 ; GB 2009-12-08
        note: run on ../../xml/02_master/workspace.xml
        set parameters:
            leiden-style = 'edh-names'
            verse-lines = 'no'
    -->

    <xsl:import href="../epidoc/example-xslt/start-txt.xsl"/>
    <xsl:strip-space elements="w name"/>

    <xsl:output method="xml" indent="no" encoding="UTF-8"/>

    <xsl:template match="/">
        <IRT_texts>
            <xsl:for-each select="//file">
                <xsl:variable name="filename" select="concat('../../xml/workspace/',.)"/>
                <xsl:if
                    test="not(document('../../xml/edh/edh-and-irt.xml')//irt[. = substring-before(current(),'.xml')])
                    and document($filename)//persName[not(@type='divine')]//name">
                    <xsl:for-each select="document($filename)//TEI.2">
                        <text id="{@id}">
                            <xsl:for-each
                                select="//div[@type='edition'][not(@subtype)]//persName[not(@type='divine')][descendant::name]">
                                <name>
                                    <xsl:apply-templates/>
                                </name>
                            </xsl:for-each>
                        </text>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </IRT_texts>
    </xsl:template>

    <xsl:template match="div/head"/>

</xsl:stylesheet>
