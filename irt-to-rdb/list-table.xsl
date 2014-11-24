<?xml version="1.0" encoding="UTF-8"?>

<!-- ##########################################-->
<!-- #           create dynamic database tables from IRT XML              # -->
<!-- #                       resp: GB       date: 2009-08-17                                # -->
<!-- ##########################################-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output encoding="UTF-8" method="xml" version="1.0" indent="yes"/>

    <xsl:template match="/">
        <xsl:element name="table">
            <xsl:for-each select="//file">
                <xsl:variable name="filename">
                    <xsl:text>../../xml/workspace/</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:for-each select="document($filename)">
                    <xsl:element name="inscription">
                        <xsl:element name="inscriptionID">
                            <xsl:value-of select="//TEI.2/@id"/>
                        </xsl:element>
                        <xsl:element name="inscriptionTitle">
                            <xsl:value-of select="//titleStmt/title"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
