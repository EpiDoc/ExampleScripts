<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- ============================================================= -->

    <xsl:include href="../intermed/z_common.xsl"/>

    <xsl:template match="/">
        <body>
            <xsl:variable name="nymrefs" >
                <xsl:for-each select="//file">
                    <xsl:variable name="filename">
                        <xsl:text>../../xml/workspace/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:for-each
                        select="document($filename)//t:div[@type='edition']//t:name[ancestor::*[@xml:lang][1][@xml:lang='la'] and not(child::seg/@part=('F','I','M'))]">
                        <xsl:element name="name">
                            <xsl:if test="string(@nymRef)">
                                <xsl:attribute name="nymRef">
                                    <xsl:value-of select="@nymRef"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each-group select="$nymrefs//name"
                group-by="translate(normalize-space(.), ' ', '')">
                <xsl:sort
                    select="translate(normalize-space(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuuwxyz')), ' ', '')"/>
                <name>
                    <xsl:attribute name="n">
                        <xsl:number value="position()"/>
                    </xsl:attribute>
                    <form>
                        <xsl:value-of select="translate(normalize-space(.), ' ', '')"/>
                    </form>
                    <reg>
                        <xsl:value-of select="@nymRef"/>
                    </reg>
                    <type>
                        <xsl:value-of select="@type"/>
                    </type>
                    <count>
                        <xsl:value-of
                            select="count($nymrefs//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')])"
                        />
                    </count>
                    <allregs>
                        <xsl:for-each-group
                            select="$nymrefs//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')]"
                            group-by="concat(translate(normalize-space(.), ' ', ''),@nymRef)">
                            <xsl:value-of select="@nymRef"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each-group>
                    </allregs>
                    <alltypes>
                        <xsl:for-each-group
                            select="$nymrefs//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')]"
                            group-by="concat(translate(normalize-space(.), ' ', ''),@type)">
                            <xsl:value-of select="@type"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each-group>
                    </alltypes>
                </name>
            </xsl:for-each-group>
        </body>
    </xsl:template>

</xsl:stylesheet>
