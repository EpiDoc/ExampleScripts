<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" version="2.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- ============== run against ../../xmod/webapp/root/xml/alist/inscriptions.xml ============== -->
    
    <xsl:include href="../z_common.xsl"/>

    <xsl:template match="/">
        <body>
            <xsl:variable name="lemmata" >
                <xsl:for-each select="//file">
                    <xsl:variable name="filename">
                        <xsl:text>../../xmod/webapp/root/xml/content/inscriptions/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:for-each
                        select="document($filename)//t:div[@type='edition']//t:placeName">
                        <xsl:element name="placeName">
                            <xsl:if test="string(@nymRef)">
                                <xsl:attribute name="nymRef">
                                    <xsl:value-of select="@nymRef"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="string(@type)">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@type"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each-group select="$lemmata//placeName"
                group-by="translate(normalize-space(.), ' ', '')">
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
                    <xsl:if test="@type='ethnic'">
                        <ethnic>yes</ethnic>
                    </xsl:if>
                    <count>
                        <xsl:value-of
                            select="count($lemmata//placeName[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')])"
                        />
                    </count>
                    <alllemmata>
                        <xsl:for-each-group
                            select="$lemmata//placeName[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')]"
                            group-by="concat(translate(normalize-space(.), ' ', ''),@nymRef)">
                            <xsl:value-of select="@nymRef"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each-group>
                    </alllemmata>
                </word>
            </xsl:for-each-group>
        </body>
    </xsl:template>

</xsl:stylesheet>
