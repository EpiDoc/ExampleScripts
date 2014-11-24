<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:t="http://www.tei-c.org/ns/1.0">

    <xsl:output method="text" encoding="UTF-8"/>
    
    <!-- ============== run against ../../xml/03alist/workspace.xml ============== -->
    
    <xsl:include href="../intermed/z_common.xsl"/>

    <xsl:template match="/">
        
            <xsl:variable name="lemmata">
                <xsl:for-each select="//file">
                    <xsl:variable name="filename">
                        <xsl:text>../../xml/workspace/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:for-each
                        select="document($filename)//t:div[@type='edition']//t:w[ancestor::t:*[@xml:lang][1][@xml:lang='grc'] and not(@part=('F','I','M','Y')) and not(@lemma)]">
                        <xsl:element name="w">
                            <xsl:value-of select="lower-case(.)"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:for-each-group select="$lemmata//w"
                group-by="translate(normalize-space(.), ' ', '')">
                <xsl:sort
                    select="translate(normalize-space(translate(.,$grkb4,$grkafter)), ' ', '')"/>
                        <xsl:value-of select="translate(normalize-space(.), ' ', '')"/>
                        <xsl:text>
</xsl:text>
            </xsl:for-each-group>
    </xsl:template>

</xsl:stylesheet>
