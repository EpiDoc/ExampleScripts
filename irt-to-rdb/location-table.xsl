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

                    <!--  &&&&&&&&&&  Findspot (one per monuList)  &&&&&&&&&&&&  -->
                    <xsl:for-each-group select="//rs[@type='found']//rs[@type='monuList']" group-by="@key">
                        <xsl:element name="relation">
                            <xsl:element name="inscriptionID">
                                <xsl:value-of select="ancestor::TEI.2/@id"/>
                            </xsl:element>
                            <xsl:element name="locusType">
                                <xsl:text>findspot</xsl:text>
                            </xsl:element>
                            <xsl:element name="locusID">
                                <xsl:value-of select="substring-after(@key, 'db')"/>
                            </xsl:element>
                            <xsl:element name="context">
                                <xsl:value-of select="normalize-space(ancestor::rs[@type='found'])"
                                />
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each-group>

                    <!--  &&&&&&&&&&  Findspot (if no monuList use ancientFindspot)  &&&&&&&&&&&&  -->
                    <xsl:for-each
                        select="//rs[@type='found'][not(descendant::rs[@type='monuList'])]//placeName[@type='ancientFindspot'][@key]">
                        <xsl:element name="relation">
                            <xsl:element name="inscriptionID">
                                <xsl:value-of select="ancestor::TEI.2/@id"/>
                            </xsl:element>
                            <xsl:element name="locusType">
                                <xsl:text>findspot</xsl:text>
                            </xsl:element>
                            <xsl:element name="locusID">
                                <xsl:value-of select="substring-after(@key, 'db')"/>
                            </xsl:element>
                            <xsl:element name="context">
                                <xsl:value-of select="normalize-space(ancestor::rs[@type='found'])"
                                />
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>

                    <!--  &&&&&&&&&&  Original Location (if monuList) &&&&&&&&&&&&  -->
                    <xsl:for-each-group select="//rs[@type='origLocation']//rs[@type='monuList']" group-by="@key">
                        <xsl:element name="relation">
                            <xsl:element name="inscriptionID">
                                <xsl:value-of select="ancestor::TEI.2/@id"/>
                            </xsl:element>
                            <xsl:element name="locusType">
                                <xsl:text>original location</xsl:text>
                            </xsl:element>
                            <xsl:element name="locusID">
                                <xsl:value-of select="substring-after(@key, 'db')"/>
                            </xsl:element>
                            <xsl:element name="context">
                                <xsl:value-of
                                    select="normalize-space(ancestor::rs[@type='origLocation'])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each-group>
                    <!--  &&&&&&&&&&  Original Location (if == "findspot") &&&&&&&&&&&&  -->

                    <xsl:for-each
                        select="//rs[@type='origLocation'][not(rs[@type='monuList'])][contains(., 'Findspot') and ancestor::div//rs[@type='found']//*[@key]]">
                        <xsl:element name="relation">
                            <xsl:element name="inscriptionID">
                                <xsl:value-of select="ancestor::TEI.2/@id"/>
                            </xsl:element>
                            <xsl:element name="locusType">
                                <xsl:text>original location</xsl:text>
                            </xsl:element>
                            <xsl:element name="locusID">
                                <xsl:choose>
                                    <xsl:when
                                        test="ancestor::div//rs[@type='found']//rs[@type='monuList'][@key]">
                                        <xsl:value-of
                                            select="substring-after(ancestor::div//rs[@type='found']//rs[@type='monuList']/@key, 'db')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="ancestor::div//rs[@type='found']//placeName[@type='ancientFindspot'][@key]">
                                        <xsl:value-of
                                            select="substring-after(ancestor::div//rs[@type='found']//placeName[@type='ancientFindspot']/@key, 'db')"
                                        />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:element>
                            <xsl:element name="context">
                                <xsl:value-of
                                    select="normalize-space(ancestor::div//rs[@type='found'])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>

                    <!--  &&&&&&&&&&  Last recorded Location (if tagged) &&&&&&&&&&&&  -->

                    <xsl:for-each-group select="//rs[@type='lastLocation']//rs[@type='monuList']" group-by="@key">
                        <xsl:element name="relation">
                            <xsl:element name="inscriptionID">
                                <xsl:value-of select="ancestor::TEI.2/@id"/>
                            </xsl:element>
                            <xsl:element name="locusType">
                                <xsl:text>last recorded location</xsl:text>
                            </xsl:element>
                            <xsl:element name="locusID">
                                <xsl:value-of select="substring-after(@key, 'db')"/>
                            </xsl:element>
                            <xsl:element name="context">
                                <xsl:value-of
                                    select="normalize-space(ancestor::rs[@type='lastLocation'])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each-group>

                    <!--  &&&&&&&&&&  Last recorded Location (if == "findpot") &&&&&&&&&&&&  -->

                    <xsl:for-each
                        select="//rs[@type='lastLocation'][not(rs[@type='monuList'])][contains(., 'findspot') and ancestor::div//rs[@type='found']//*[@key]]">
                        <xsl:element name="relation">
                            <xsl:element name="inscriptionID">
                                <xsl:value-of select="ancestor::TEI.2/@id"/>
                            </xsl:element>
                            <xsl:element name="locusType">
                                <xsl:text>last recorded location</xsl:text>
                            </xsl:element>
                            <xsl:element name="locusID">
                                <xsl:choose>
                                    <xsl:when
                                        test="ancestor::div//rs[@type='found']//rs[@type='monuList'][@key]">
                                        <xsl:value-of
                                            select="substring-after(ancestor::div//rs[@type='found']//rs[@type='monuList']/@key, 'db')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="ancestor::div//rs[@type='found']//placeName[@type='ancientFindspot'][@key]">
                                        <xsl:value-of
                                            select="substring-after(ancestor::div//rs[@type='found']//placeName[@type='ancientFindspot']/@key, 'db')"
                                        />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:element>
                            <xsl:element name="context">
                                <xsl:value-of
                                    select="normalize-space(ancestor::div//rs[@type='found'])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
