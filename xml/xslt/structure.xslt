<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:template match="section|appendix|finding|non-finding|annex">
        <xsl:if test="not(@visibility='hidden')">
            <fo:block xsl:use-attribute-sets="section">
            <xsl:if test="self::appendix or self::annex">
                <xsl:attribute name="break-before">page</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </fo:block>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="title">
        <xsl:variable name="LEVEL" select="count(ancestor::*) - 1"/>
        <xsl:variable name="CLASS">
            <!-- use title-x for all levels -->
            <xsl:text>title-</xsl:text>
            <xsl:value-of select="$LEVEL"/>
        </xsl:variable>
        
        <fo:block>
            <xsl:call-template name="use-att-set">
                <xsl:with-param name="CLASS" select="$CLASS"/>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="self::title[parent::appendix]">
                    <fo:inline> Appendix&#160;<xsl:number count="appendix[not(@visibility='hidden')]" level="multiple"
                        format="{$AUTO_NUMBERING_FORMAT}"/>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="ancestor::appendix and not(self::title[parent::appendix])">
                    <fo:inline> App&#160;<xsl:number count="appendix[not(@visibility='hidden')]" level="multiple"
                        format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number count="section[ancestor::appendix][not(@visibility='hidden')]" level="multiple"
                            format="{$AUTO_NUMBERING_FORMAT}"/>
                    </fo:inline>
                </xsl:when>
                <xsl:otherwise>
                    <fo:inline>
                        <xsl:number count="section[not(@visibility='hidden')]|finding|non-finding" level="multiple"
                            format="{$AUTO_NUMBERING_FORMAT}"/>
                    </fo:inline>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#160;&#160;&#160;</xsl:text>
            <xsl:if test="parent::finding">
                <!-- prepend finding id (XXX-NNN) -->
                <xsl:apply-templates select=".." mode="number"/>
                <xsl:text> &#8212; </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
        <xsl:if test="parent::finding">
            <xsl:apply-templates select=".." mode="meta"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>