<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    version="2.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- ========== run on ../../xml/03_alist/workspace.xml ============== -->

    <xsl:include href="../intermed/z_common.xsl"/>

    <xsl:template match="/">
        <body>
            <xsl:variable name="emperors" >
                <xsl:for-each select="//file">
                    <xsl:variable name="filename">
                        <xsl:text>../../xml/workspace/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:for-each
                        select="document($filename)//t:div[@type='edition']//t:persName[@type='emperor']">
                        <xsl:element name="token">
                            <xsl:if test="string(@nymRef)">
                                <xsl:attribute name="nymRef">
                                    <xsl:value-of select="@nymRef"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="string(@key)">
                                <xsl:attribute name="key">
                                    <xsl:value-of select="@key"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each-group select="$emperors//token"
                group-by="translate(normalize-space(.), ' ', '')">
                <xsl:sort
                    select="translate(normalize-space(translate(.,$grkb4,$grkafter)), ' ', '')"/>
                <word>
                    <xsl:attribute name="n">
                        <xsl:number value="position()"/>
                    </xsl:attribute>
                    <token>
                        <xsl:value-of select="normalize-space(.)"/>
                    </token>
                    <nymRef>
                        <xsl:value-of select="@nymRef"/>
                    </nymRef>
                    <key>
                        <xsl:value-of select="@key"/>
                    </key>
                    <count>
                        <xsl:value-of
                            select="count(current-group())"
                        />
                    </count>
                    <allnymrefs>
                        <xsl:for-each-group
                            select="$emperors//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')]"
                            group-by="concat(translate(normalize-space(.), ' ', ''),@nymRef)">
                            <xsl:value-of select="@nymRef"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each-group>
                    </allnymrefs>
                    <allkeys>
                        <xsl:for-each-group
                            select="$emperors//name[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')]"
                            group-by="concat(translate(normalize-space(.), ' ', ''),@key)">
                            <xsl:value-of select="@key"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each-group>
                    </allkeys>
                </word>
            </xsl:for-each-group>
        </body>
    </xsl:template>

</xsl:stylesheet>
