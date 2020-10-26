<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- ============================================================= -->

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
                        select="document($filename)//t:div[@type='edition']//t:w[ancestor::*[@xml:lang][1][@xml:lang='la'] and not(@part=('F','I','M'))]">
                        <xsl:element name="w">
                            <xsl:if test="string(@lemma)">
                                <xsl:attribute name="lemma">
                                    <xsl:value-of select="@lemma"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each-group select="$lemmata//w"
                group-by="translate(normalize-space(.), ' ', '')">
                <xsl:sort
                    select="translate(normalize-space(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuuwxyz')), ' ', '')"/>
                <word>
                    <xsl:attribute name="n">
                        <xsl:number value="position()"/>
                    </xsl:attribute>
                    <token>
                        <xsl:value-of select="translate(normalize-space(.), ' ', '')"/>
                    </token>
                    <lemma>
                        <xsl:value-of select="@lemma"/>
                    </lemma>
                    <count>
                        <xsl:value-of
                            select="count($lemmata//w[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')])"
                        />
                    </count>
                    <alllemmata>
                        <xsl:for-each-group
                            select="$lemmata//w[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')]"
                            group-by="concat(translate(normalize-space(.), ' ', ''),@lemma)">
                            <xsl:value-of select="@lemma"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each-group>
                    </alllemmata>
                </word>
            </xsl:for-each-group>
        </body>
    </xsl:template>

</xsl:stylesheet>
