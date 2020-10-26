<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" version="2.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- ============== run against ../../xmod/webapp/root/xml/alists/inscriptions.xml ============== -->
    
    <xsl:include href="../z_common.xsl"/>

    <xsl:template match="/">
        <body>
            <xsl:variable name="persons" >
                <xsl:for-each select="//file">
                    <xsl:variable name="filename">
                        <xsl:text>../../xmod/webapp/root/xml/content/inscriptions/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:for-each
                        select="document($filename)//t:div[@type='edition']//t:persName[@type='attested']">
                        <xsl:element name="persName">
                            <xsl:attribute name="inscription">
                                <xsl:value-of select="//t:idno[@type='filename']"/>
                            </xsl:attribute>
                            <xsl:if test="string(@ref)">
                                <xsl:attribute name="ref">
                                    <xsl:value-of select="@ref"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <!--<xsl:for-each-group select="$persons//placeName"
                group-by="translate(normalize-space(.), ' ', '')">-->
            <xsl:for-each select="$persons//persName">
                <!--<xsl:sort
                    select="translate(normalize-space(translate(.,$grkb4,$grkafter)), ' ', '')"/>-->
                <person>
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="concat('person',string(position()))"/>
                    </xsl:attribute>
                    <persName xml:lang="grc">
                        <xsl:value-of select="normalize-unicode(normalize-space(.))"/>
                    </persName>
                    <persName xml:lang="ru"/>
                    <persName xml:lang="en"/>
                    <floruit/>
                    <relationship/>
                    <office/>
                    <inscription>
                        <xsl:text>byz.</xsl:text>
                        <xsl:value-of select="number(substring-after(@inscription,'byz'))"/>
                    </inscription>
                    <!--<count>
                        <xsl:value-of
                            select="count($persons//placeName[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')])"
                        />
                    </count>-->
                </person>
            </xsl:for-each>
        </body>
    </xsl:template>

</xsl:stylesheet>
