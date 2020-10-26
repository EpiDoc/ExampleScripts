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
                        select="document($filename)//t:div[@type='edition']//t:name[ancestor-or-self::t:*[@xml:lang][1][@xml:lang='grc'] and not(child::t:seg[@part=('F','I','M','Y')])]">
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
            <xsl:for-each-group select="$lemmata//name[not(@nymRef)]"
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
                    <nymRef>
                        <xsl:value-of select="@nymRef"/>
                    </nymRef>
                    <count>
                        <xsl:value-of
                            select="count($lemmata//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')])"
                        />
                    </count>
                    <alllemmata>
                        <xsl:for-each-group
                            select="$lemmata//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')]"
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
