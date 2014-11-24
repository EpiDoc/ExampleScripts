<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <!-- ============== run against ../../xml/03_alist/workspace.xml ============== -->
    
    <xsl:include href="../intermed/z_common.xsl"/>

    <xsl:template match="/">
            <xsl:variable name="criteria">
                <xsl:for-each select="//file">
                    <xsl:variable name="filename">
                        <xsl:text>../../xml/workspace/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:for-each select="document($filename)//t:origDate[@evidence]">
                        <xsl:for-each select="tokenize(@evidence,' ')">
                        <xsl:element name="item">
                            <xsl:value-of select="."/>
                        </xsl:element>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
        
        <body>
            <xsl:for-each-group select="$criteria//item"
                group-by="normalize-space(.)">
                <xsl:sort
                    select="normalize-space(.)"/>
                <criterion>
                    <xsl:attribute name="n">
                        <xsl:number value="position()"/>
                    </xsl:attribute>
                    <val>
                        <xsl:value-of select="translate(., '-', ' ')"/>
                    </val>
                    <count>
                        <xsl:value-of
                            select="count($criteria//item[translate(normalize-space(.), ' ', '')=translate(normalize-space(current()), ' ', '')])"
                        />
                    </count>
                    
                </criterion>
            </xsl:for-each-group>
        </body>
    </xsl:template>

</xsl:stylesheet>
