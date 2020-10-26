<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- ============== run against ../../xml/03_alist/workspace.xml ============== -->

    <xsl:include href="../intermed/z_common.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="execution">
            <xsl:for-each select="//file">
                <xsl:variable name="filename">
                    <xsl:text>../../xml/workspace/</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:for-each select="document($filename)//t:rs[@type='execution']">
                    <xsl:element name="item">
                        
                            <xsl:attribute name="key">
                                <xsl:value-of select="@key"/>
                            </xsl:attribute>
                        
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>

        <body>
            <xsl:for-each-group select="$execution//item" group-by="concat(lower-case(normalize-space(.)),@key)">
                <xsl:sort select="lower-case(normalize-space(.))"/>
                <textType>
                    <xsl:attribute name="n">
                        <xsl:number value="position()"/>
                    </xsl:attribute>
                    <val>
                        <xsl:value-of select="lower-case(normalize-space(.))"/>
                    </val>
                    <key>
                        <xsl:value-of select="@key"/>
                    </key>
                    <count>
                        <xsl:value-of
                            select="count(current-group())" />
                    </count>

                </textType>
            </xsl:for-each-group>
        </body>
    </xsl:template>

</xsl:stylesheet>
