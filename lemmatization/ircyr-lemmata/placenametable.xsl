<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" version="2.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- =========== run on ../../xml/03_alist/workspace.xml ============== -->

    <xsl:include href="../intermed/z_common.xsl"/>

    <xsl:template match="/">
        <body>
            <xsl:variable name="lemmata" >
                <xsl:for-each select="//file">
                    <xsl:variable name="filename">
                        <xsl:text>../../xml/workspace/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:for-each
                        select="document($filename)//t:div[@type='edition']//t:placeName">
                        <xsl:copy>
                            <xsl:copy-of select="@*"/>
                            <xsl:value-of select="."/>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each-group select="$lemmata//t:placeName"
                group-by="lower-case(translate(normalize-space(.), ' ', ''))">
                <xsl:sort
                    select="translate(normalize-space(translate(.,$grkb4,$grkafter)), ' ', '')"/>
                <word>
                    <xsl:attribute name="n">
                        <xsl:number value="position()"/>
                    </xsl:attribute>
                    <token>
                        <xsl:value-of select="translate(normalize-space(.), ' ', '')"/>
                    </token>
                    <reg>
                        <xsl:value-of select="@nymRef"/>
                    </reg>
                    <count>
                        <xsl:value-of
                            select="count(current-group())"
                        />
                    </count>
                    <allregs>
                        <xsl:for-each-group
                            select="$lemmata//t:placeName[lower-case(translate(normalize-space(.), ' ', ''))=lower-case(translate(normalize-space(current()), ' ', ''))]"
                            group-by="concat(translate(normalize-space(.), ' ', ''),@nymRef)">
                            <xsl:value-of select="@nymRef"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each-group>
                    </allregs>
                </word>
            </xsl:for-each-group>
        </body>
    </xsl:template>

</xsl:stylesheet>
