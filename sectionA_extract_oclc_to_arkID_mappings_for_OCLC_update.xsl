<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ead="urn:isbn:1-931666-22-9"
    version="2.0">
 

<xsl:output method="text" omit-xml-declaration="yes" encoding="utf-8"/>

<!-- Tab variable for creating TSV file -->
<xsl:variable name="tab">
    <xsl:text>&#x09;</xsl:text>
</xsl:variable>

<!-- New Line variable for creating new rows in TSV file -->
<xsl:variable name="newline">
    <xsl:text>&#xa;</xsl:text>
</xsl:variable>

<!-- Locates all origination/persname terms -->
 
       
<xsl:template match="/">

  
    <xsl:text>eadid</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>oclc_num</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>aleph_num</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>DDR_URI</xsl:text>
    <xsl:value-of select="$newline"/> 
     

    <xsl:for-each select="collection('file:///F:/SpeColl/TECHNICAL SERVICES/Technical Services Department/xml/toolkit/?select=*.xml')">
    
<!-- <xsl:if test="contains(//ead:c01[1]/@id,'aspace_seca')"> -->
       <xsl:if test="//ead:num[@type='oclc']">
         <xsl:value-of select="//ead:eadid"/>
         <xsl:value-of select="$tab"/>
         <xsl:value-of select="//ead:num[@type='oclc']"/>
         <xsl:value-of select="$tab"/>
         <xsl:value-of select="//ead:num[@type='aleph']"/>
         <xsl:value-of select="$tab"/>
         <xsl:value-of select="//ead:dao[1]/@xlink:href"/>
         <xsl:value-of select="$newline"/>
       </xsl:if>
        
      </xsl:for-each>
    
    
            
    </xsl:template>


 
</xsl:stylesheet>