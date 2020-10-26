<?xml version="1.0"?>

<!-- XSLT to insert lemmata from the grcwordtable into <w> elements in IOSPE inscriptions -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:date="http://exslt.org/dates-and-times" >
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

    <!-- ||||||||||||||||||||||  copy all existing elements, comments  |||||||||||||||| -->

    <xsl:template match="t:*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="//comment()">
        <xsl:copy>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="//processing-instruction()">
        <xsl:text>
</xsl:text>
        <xsl:copy>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>    
    
    <xsl:template match="t:TEI">
        <xsl:text>
</xsl:text>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- ||||||||||||||||||||||   words  ||||||||||||||||||||||||| -->

    <xsl:template
        match="//t:div[@type='edition']//t:w[not(@part) and not(@lemma)]">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:choose>
                <!--<xsl:when
                    test="ancestor-or-self::t:*[@xml:lang][1]/@xml:lang='la' and
                        document('../../xml/lemmata/la-wordsout.xml')//word[translate(normalize-space(token), ' ', '')
                        = translate(normalize-space(current()), ' ', '')][string(translate(normalize-space(lemma), ' ', ''))]">
                    <xsl:attribute name="lemma">
                        <xsl:value-of
                            select="translate(normalize-space(document('../../xml/lemmata/la-wordsout.xml')//word[translate(normalize-space(token), ' ', '')=translate(normalize-space(current()), ' &#xA;', '')][1]/lemma), ' ', '')"
                        />
                    </xsl:attribute>
                </xsl:when>-->
                <xsl:when
                    test="ancestor-or-self::t:*[@xml:lang][1][@xml:lang='grc'] and
                    document('../../xmod/webapp/root/xml/tables/grc-wordsout.xml')//word[normalize-unicode(lower-case(translate(normalize-space(token), ' ', '')))
                        = normalize-unicode(lower-case(translate(normalize-space(current()), ' ', '')))][string(translate(normalize-space(lemma), ' ', ''))]">
                    <xsl:attribute name="lemma">
                        <xsl:value-of
                            select="normalize-unicode(translate(normalize-space(document('../../xmod/webapp/root/xml/tables/grc-wordsout.xml')//word[normalize-unicode(lower-case(translate(normalize-space(token), ' ', '')))=normalize-unicode(lower-case(translate(normalize-space(current()), ' &#xA;', '')))][1]/lemma), ' ', ''))"
                        />
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- ||||||||||||||||||||||   normalize-unicode  ||||||||||||||||||||||||| -->
    
    <xsl:template match="t:div[@type='edition']//text()">
        <xsl:value-of select="normalize-unicode(.)"/>
    </xsl:template>
    
    <xsl:template match="@lemma|@nymRef">
        <xsl:copy>
            <xsl:value-of select="normalize-unicode(.)"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- ||||||||||||||||||||||   change  ||||||||||||||||||||||||| -->
    
    <xsl:template match="t:revisionDesc">
        <xsl:element name="{local-name()}">
            <xsl:if test="//t:div[@type='edition']//t:w[not(@part) and not(@lemma)]">
                <xsl:text>
         </xsl:text>
                <xsl:element name="change">
                    <xsl:attribute name="when">
                        <xsl:value-of select="substring(date:date(),1,10)"/>
                    </xsl:attribute>
                    <xsl:attribute name="who">
                        <xsl:text>GB</xsl:text>
                    </xsl:attribute>
                    <xsl:text>inserted Greek lemmata (and normalized unicode)</xsl:text>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
