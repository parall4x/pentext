<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template match="generate_index">
        <fo:block xsl:use-attribute-sets="title-toc">Table of Contents</fo:block>
        <fo:block xsl:use-attribute-sets="index">
            <fo:block>
                <fo:table width="100%">
                    <fo:table-column/>
                    <fo:table-column column-width="7mm"/>
                    <fo:table-body>
                        <xsl:apply-templates select="/" mode="toc"/>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template match="meta | *[ancestor-or-self::*/@visibility = 'hidden']" mode="toc"/>

    <!-- meta, hidden things and children of hidden things not indexed -->

    <xsl:template
        match="section[not(@visibility = 'hidden')] | finding | appendix[not(@visibility = 'hidden')] | non-finding"
        mode="toc">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="$execsummary = true()">
                <xsl:if test="ancestor-or-self::*/@inexecsummary = 'yes'">
                    <xsl:call-template name="ToC"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ToC"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="ToC">
        <xsl:param name="execsummary" tunnel="yes"/>
        <fo:table-row>
            <fo:table-cell text-align-last="justify">
                <fo:block>
                    <fo:basic-link>
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:call-template name="tocContent"/>
                    </fo:basic-link>
                    <xsl:text>&#xA0;</xsl:text>
                    <fo:leader leader-pattern="dots" leader-alignment="reference-area"
                        leader-length.maximum="21cm"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-right="3pt" display-align="after">
                <fo:block text-align="right">
                    <fo:basic-link>
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <fo:page-number-citation ref-id="{@id}"/>
                    </fo:basic-link>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <xsl:choose>
            <xsl:when test="$execsummary = true()">
                <xsl:apply-templates
                    select="section[not(@visibility = 'hidden')][not(../@visibility = 'hidden')][ancestor-or-self::*/@inexecsummary = 'yes']"
                    mode="toc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates
                    select="section[not(@visibility = 'hidden')][not(../@visibility = 'hidden')] | finding[not(../@visibility = 'hidden')] | non-finding[not(../@visibility = 'hidden')]"
                    mode="toc"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="tocContent">
        <xsl:call-template name="tocContent_Numbering"/>
        <xsl:text>&#xA0;&#xA0;</xsl:text>
        <xsl:call-template name="tocContent_Title"/>
    </xsl:template>

    <xsl:template name="tocContent_Title">
        <xsl:apply-templates select="title" mode="toc"/>
    </xsl:template>

    <xsl:template match="title" mode="toc">
        <xsl:call-template name="prependNumber"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="tocContent_Numbering">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="self::appendix[not(@visibility = 'hidden')]">
                <xsl:choose>
                    <xsl:when test="$execsummary = true()">
                        <fo:inline> Appendix&#160;<xsl:number
                                count="appendix[not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/></fo:inline>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline> Appendix&#160;<xsl:number
                                count="appendix[not(@visibility = 'hidden')]" level="multiple"
                                format="{$AUTO_NUMBERING_FORMAT}"/></fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::appendix[not(@visibility = 'hidden')]">
                <xsl:choose>
                    <xsl:when test="$execsummary = true()">
                        <xsl:if test="ancestor::appendix[@inexecsummary = 'yes']">
                            <fo:inline> App&#160;<xsl:number
                                    count="appendix[not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                    count="section[not(@visibility = 'hidden')][ancestor-or-self::*/@inexecsummary = 'yes'][ancestor::appendix[not(@visibility = 'hidden')]]"
                                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                            </fo:inline>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline> App&#160;<xsl:number
                                count="appendix[not(@visibility = 'hidden')]" level="multiple"
                                format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                count="section[not(@visibility = 'hidden')][ancestor::appendix[not(@visibility = 'hidden')]]"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$execsummary = true()">
                        <xsl:number
                            count="section[not(@visibility = 'hidden')][ancestor-or-self::*/@inexecsummary = 'yes']"
                            level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline>
                            <xsl:number
                                count="section[not(@visibility = 'hidden')] | finding | non-finding"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
