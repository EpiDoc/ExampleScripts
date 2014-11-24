<?xml version="1.0" ?>

<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/2005/Atom"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="http://www.w3.org/2005/Atom" 
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:t="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" exclude-result-prefixes="#all"/>

    <xsl:template match="files">
        <xsl:element name="feed">

            <!-- FEED HEADER -->

            <xsl:for-each select="document('../../xml/atom/feedheader.xml')/a:feed/a:author">
                <xsl:element name="author">
                    <xsl:element name="name">
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
            <xsl:element name="title">
                <xsl:value-of select="document('../../xml/atom/feedheader.xml')/a:feed/a:title[1]"/>
            </xsl:element>
            <xsl:for-each select="document('../../xml/atom/feedheader.xml')/a:feed/a:link">
                <xsl:element name="link">
                    <xsl:copy-of select="@*"/>
                </xsl:element>
            </xsl:for-each>

            <!-- FIND MOST RECENT UPDATE IN WHOLE COLLECTION -->

            <xsl:element name="updated">
                <xsl:variable name="last-per-file">
                    <xsl:for-each select="document('../../xml/02_master/workspace.xml')//file">
                        <xsl:variable name="fn" select="concat('../../xml/workspace/',.)"/>
                        <xsl:variable name="first-date">
                            <xsl:for-each select="document($fn)//revisionDesc/change/date">
                                <xsl:sort select="year-from-date(.)" order="descending"/>
                                <xsl:sort select="month-from-date(.)" order="descending"/>
                                <xsl:sort select="day-from-date(.)" order="descending"/>
                                <xsl:sequence select="."/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:sequence select="$first-date/date[1]"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="last-sorted">
                    <xsl:for-each select="$last-per-file/date">
                        <xsl:sort select="year-from-date(.)" order="descending"/>
                        <xsl:sort select="month-from-date(.)" order="descending"/>
                        <xsl:sort select="day-from-date(.)" order="descending"/>
                        <xsl:sequence select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:value-of select="$last-sorted/date[1]"/>
                <xsl:text>T00:00:00Z</xsl:text>
            </xsl:element>
            
                <!-- GENERATE UNIQUE ID -->
            
            <xsl:element name="id">
                <xsl:text>tag:</xsl:text>
                <xsl:value-of
                    select="substring-before(substring-after(document('../../xml/atom/feedheader.xml')/a:feed/a:link[@rel='alternate']/@href,'http://'),'/')"/>
                <xsl:text>,</xsl:text>
                <xsl:choose>
                    <xsl:when test="starts-with(//file[1], 'IRT')">
                        <xsl:text>2009</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(//file[1], 'IAph')">
                        <xsl:text>2007</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(//file[1], 'eAla')">
                        <xsl:text>2004</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('ABCGPT',substring(//file[1],1,1))">
                        <xsl:text>2010</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:text>:</xsl:text>
                <xsl:value-of
                    select="substring-before(substring-after(document('../../xml/atom/feedheader.xml')/a:feed/a:link[@rel='alternate']/@href,'kcl.ac.uk'),'.html')"
                />
            </xsl:element>

            <!-- ONE ENTRY PER INSCRIPTION -->

            <xsl:for-each select="document('../../xml/02_master/workspace.xml')//file">
                <xsl:variable name="fn">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:for-each select="document(concat('../../xml/workspace/',$fn))">
                    <xsl:element name="entry">

                        <!-- EDITOR(S) -->

                        <xsl:for-each select="//titleStmt//editor">
                            <xsl:element name="author">
                                <xsl:element name="name">
                                    <xsl:value-of select="."/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>

                        <!-- RIGHTS -->

                        <xsl:element name="rights">
                            <xsl:value-of select="normalize-space(//publicationStmt)"/>
                        </xsl:element>

                        <!-- generate ID -->

                        <xsl:element name="id">
                            <xsl:text>tag:</xsl:text>
                            <xsl:value-of
                                select="substring-before(substring-after(document('../../xml/atom/feedheader.xml')/a:feed/a:link[@rel='alternate']/@href,'http://'),'/')"/>
                            <xsl:text>,</xsl:text>
                            <xsl:choose>
                                <xsl:when test="starts-with(//TEI.2/@id, 'IRT')">
                                    <xsl:text>2009</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(//TEI.2/@id, 'IAph')">
                                    <xsl:text>2007</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(//TEI.2/@id, 'eAla')">
                                    <xsl:text>2004</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains('ABCGPT',substring(//TEI.2/@id,1,1))">
                                    <xsl:text>2010</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:text>:</xsl:text>
                            <xsl:value-of
                                select="substring-before(substring-after(document('../../xml/atom/feedheader.xml')/a:feed/a:link[@rel='alternate']/@href,'kcl.ac.uk'),'index.html')"/>
                            <xsl:value-of select="//TEI.2/@id"/>
                        </xsl:element>

                        <!-- TITLE -->

                        <xsl:element name="title">
                            <xsl:value-of select="//titleStmt/title"/>
                        </xsl:element>

                        <!-- REL ALTERNATE: HTML -->
                        
                        <xsl:element name="link">
                            <xsl:attribute name="rel">
                                <xsl:text>alternate</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                                <xsl:text>text/html</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="substring-before(document('../../xml/atom/feedheader.xml')/a:feed/a:link[@rel='alternate']/@href, 'index.html')"/>
                                <xsl:value-of select="//TEI.2/@id"/>
                                <xsl:text>.html</xsl:text>
                            </xsl:attribute>
                        </xsl:element>
                        
                        <!-- REL ALTERNATE: XML -->
                        
                        <xsl:element name="link">
                            <xsl:attribute name="rel">
                                <xsl:text>alternate</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                                <xsl:text>text/xml</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="substring-before(document('../../xml/atom/feedheader.xml')/a:feed/a:link[@rel='alternate']/@href, 'index.html')"/>
                                <xsl:value-of select="//TEI.2/@id"/>
                                <xsl:text>.xml</xsl:text>
                            </xsl:attribute>
                        </xsl:element>
                        
                        <!-- FINDSPOT #1: ANCIENT-->

                        <xsl:choose>
                            <!-- IAph and ALA are easy -->
                            <xsl:when
                                test="starts-with(//TEI.2/@id, 'IAph') or starts-with(//TEI.2/@id, 'eAla')">
                                <xsl:element name="link">
                                    <xsl:attribute name="rel">
                                        <xsl:text>http://gawd.atlantides.org/terms/findspot</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:text>http://pleiades.stoa.org/places/638753</xsl:text>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <!-- IRT and IRCyr need to look in locationAL for pleiades ID -->
                            <xsl:when
                                test="starts-with(//TEI.2/@id, 'IRT') or contains('ABCGPT',substring(//TEI.2/@id,1,1))">
                                <xsl:if
                                    test="document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='found']//*/@key]/bibl">
                                    <xsl:element name="link">
                                        <xsl:attribute name="rel">
                                            <xsl:text>http://gawd.atlantides.org/terms/findspot</xsl:text>
                                        </xsl:attribute>
                                        <xsl:attribute name="href">
                                            <xsl:value-of
                                                select="document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='found']//*/@key]/bibl"
                                            />
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:when>
                        </xsl:choose>

                        <!-- FINDSPOT #2: modern -->

                        <xsl:if test="//*[@type='modernFindspot']/@key">
                            <xsl:element name="link">
                                <xsl:attribute name="rel">
                                    <xsl:text>http://gawd.atlantides.org/terms/findspot</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="//*[@type='modernFindspot']/@key"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>

                        <!-- ORIGINAL LOCATION -->

                        <xsl:choose>
                            <xsl:when
                                test="document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='origLocation']//rs[@type='monuList']/@key]/bibl">
                                <xsl:element name="link">
                                    <xsl:attribute name="rel">
                                        <xsl:text>http://gawd.atlantides.org/terms/original</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='origLocation']//rs[@type='monuList']/@key]/bibl"
                                        />
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when
                                test="contains(//rs[@type='origLocation'], 'Findspot') and document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='found']//*/@key]/bibl">
                                <xsl:element name="link">
                                    <xsl:attribute name="rel">
                                        <xsl:text>http://gawd.atlantides.org/terms/original</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='found']//*/@key]/bibl"
                                        />
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>

                        <!-- other AttestedAt / last recorded location -->

                        <xsl:choose>
                            <xsl:when
                                test="document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='lastLocation']//*/@key]/bibl">
                                <xsl:element name="link">
                                    <xsl:attribute name="rel">
                                        <xsl:text>http://gawd.atlantides.org/terms/attestedAt</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='lastLocation']//*/@key]/bibl"
                                        />
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when
                                test="contains(//rs[@type='lastLocation'], 'Findspot') and document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='found']//*/@key]/bibl">
                                <xsl:element name="link">
                                    <xsl:attribute name="rel">
                                        <xsl:text>http://gawd.atlantides.org/terms/attestedAt</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="document('../../xml/03_alist/locationAL.xml')//item[@id=current()//rs[@type='found']//*/@key]/bibl"
                                        />
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>

                        <!-- MENTIONED PLACES -->

                        <xsl:if test="//div[@type='edition']//placeName/@reg">
                            <xsl:for-each
                                select="document('../../xml/03_alist/mentionedplaceAL.xml')//t:place[t:placeName = current()//placeName/@reg][descendant::t:ref[@target]]">
                                <xsl:element name="link">
                                    <xsl:attribute name="rel">
                                        <xsl:text>http://gawd.atlantides.org/terms/attestsTo</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="descendant::t:ref/@target"
                                        />
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:if>

                        <!-- EDH EQUIVS -->

                        <xsl:for-each
                            select="document('../../xml/edh/edh-and-irt.xml')//row[irt = current()//TEI.2/@id]">
                            <xsl:element name="link">
                                <xsl:attribute name="rel">
                                    <xsl:text>http://gawd.atlantides.org/terms/alternateEdition</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>http://edh-www.adw.uni-heidelberg.de/EDH/servlet/EgrForm?aktion=eingabe&amp;benutzer=gast&amp;kennwort=g2dhst&amp;f_id_nr='HD</xsl:text>
                                    <xsl:value-of select="edh"/>
                                    <xsl:text>'</xsl:text>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:for-each>

                        <!-- PHI EQUIVS -->

                        <xsl:for-each
                            select="document('../../xml/edh/phi-and-irt.xml')//row[irt = current()//TEI.2/@id]">
                            <xsl:element name="link">
                                <xsl:attribute name="rel">
                                    <xsl:text>http://gawd.atlantides.org/terms/alternateEdition</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>http://epigraphy.packhum.org/inscriptions/oi?ikey=</xsl:text>
                                    <xsl:value-of select="phi"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:for-each>

                        <!-- ENTRY DATES -->

                        <xsl:element name="published">
                            <xsl:choose>
                                <xsl:when test="starts-with(//TEI.2/@id, 'IRT')">
                                    <xsl:text>2009-09-23</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(//TEI.2/@id, 'IAph')">
                                    <xsl:text>2007-10-01</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(//TEI.2/@id, 'eAla')">
                                    <xsl:text>2004-12-18</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains('ABCGPT',substring(//TEI.2/@id,1,1))">
                                    <xsl:text>2010-04-30</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:text>T00:00:00Z</xsl:text>
                        </xsl:element>
                        <xsl:variable name="first_date">
                            <xsl:for-each select="//revisionDesc/change/date">
                                <xsl:sort select="year-from-date(.)" order="descending"/>
                                <xsl:sort select="month-from-date(.)" order="descending"/>
                                <xsl:sort select="day-from-date(.)" order="descending"/>
                                <xsl:sequence select="."/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:element name="updated">
                            <xsl:value-of select="$first_date/date[1]"/>
                            <xsl:text>T00:00:00Z</xsl:text>
                        </xsl:element>

                        <xsl:element name="summary">
                            <xsl:attribute name="type">
                                <xsl:text>text</xsl:text>
                            </xsl:attribute>
                            <xsl:variable name="summary">
                            <xsl:apply-templates
                                select="//div[@type='description'][@subtype='monument']/p"/>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates
                                select="//div[@type='description'][@subtype='text']/p"/>
                            <xsl:text> Date: </xsl:text>
                            <xsl:value-of
                                select="//div[@type='description'][@subtype='date']/p"/>
                            <xsl:text> </xsl:text>
                            <xsl:if test="//div[@type='figure']//figure">
                                <xsl:text>Photos. </xsl:text>
                            </xsl:if>
                            <xsl:value-of
                                select="//div[@type='history'][@subtype='recording']/p"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="//div[@type='bibliography']/p"/>
                            </xsl:variable>
                        <xsl:value-of select="normalize-space($summary)"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="measure">
        <xsl:apply-templates/>
        <xsl:if test="parent::rs[@type='dimensions'] and following-sibling::measure">
            <xsl:text> x </xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
