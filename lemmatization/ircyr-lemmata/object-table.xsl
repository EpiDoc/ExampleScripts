<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- ============== run against ../../xml/03_alist/workspace.xml ============== -->

    <xsl:include href="../intermed/z_common.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="object">
            <xsl:for-each select="//file">
                <xsl:variable name="filename">
                    <xsl:text>../../xml/workspace/</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:for-each select="document($filename)//t:objectType">
                    <xsl:element name="item">
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>

        <body>
            <xsl:for-each-group select="$object//item" group-by="lower-case(normalize-space(.))">
                <xsl:sort select="lower-case(normalize-space(.))"/>
                <objectType>
                    <xsl:attribute name="n">
                        <xsl:number value="position()"/>
                    </xsl:attribute>
                    <val>
                        <xsl:value-of select="lower-case(normalize-space(.))"/>
                    </val>
                    <count>
                        <xsl:value-of
                            select="count(current-group())" />
                    </count>

                </objectType>
            </xsl:for-each-group>
        </body>
    </xsl:template>

</xsl:stylesheet>
