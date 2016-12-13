<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="urn:isbn:1-931666-22-9" exclude-result-prefixes="ead">

    <xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>

    <xsl:strip-space elements="*"/>

    <xsl:variable name="tab">
        <xsl:text>&#x09;</xsl:text>
    </xsl:variable>

    <xsl:variable name="newline">
        <xsl:text>&#xa;</xsl:text>
    </xsl:variable>

    <!-- Get current file directory name for ourput file -->
    <xsl:variable name="box_number">
        <xsl:value-of select="tokenize(base-uri(), '/')[last() - 1]"/>
    </xsl:variable>

    <xsl:template match="/">

        <xsl:result-document method="text"
            href="file:/C:/users/nh48/documents/github/sectionA_project/digguides/{$box_number}.txt">

            <!-- COLUMN HEADERS -->

            <xsl:text>Container_1</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Creator</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Title</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Date_expression</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Date_normal</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Extent</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Physdesc</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Scopecontent</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Provenance</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Subject-Topical</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Subject-Name</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>Subject-Geographic</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>ASpace_componentID</xsl:text>
            <xsl:value-of select="$tab"/>

            <!-- Empty column, to be supplied after URI is established, ARKs? -->
            <xsl:text>Digital_Object_URI</xsl:text>


            <!-- BEGIN DATA ROWS -->
            <!-- !!!Process all EADs in a subfolder (e.g. seca_001). WILL NEED TO MODIFY FOR EACH SUBFOLDER!!! -->
            <xsl:for-each
                select="collection('file:/C:/Users/nh48/Documents/GitHub/sectionA_project/ead/seca_001/?select=*.xml')">

                <xsl:for-each select="ead:ead">

                    <!-- Begin Data Rows -->
                    <xsl:value-of select="$newline"/>

                    <!-- First container type and indicator, almost always Folder 1 -->
                    <xsl:value-of select="//ead:container/@type"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="//ead:container[1]"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Collection title -->
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:origination)"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Collection title -->
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:unittitle)"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Date Expression -->
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:unitdate)"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Date Normal -->
                    <xsl:value-of
                        select="normalize-space(ead:archdesc/ead:did/ead:unitdate/@normal)"/>
                    <xsl:value-of select="$tab"/>

                    <!-- controlled extent statement, typically # of items or pages -->
                    <xsl:value-of
                        select="normalize-space(ead:archdesc/ead:did/ead:physdesc/ead:extent)"/>
                    <xsl:value-of select="$tab"/>

                    <!-- any other kind of physical description if present -->
                    <xsl:value-of
                        select="normalize-space(ead:archdesc/ead:did/ead:physdesc[not(ead:extent)])"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Scopecontent notes -->
                    <xsl:for-each select="ead:archdesc/ead:scopecontent">
                        <xsl:value-of select="ead:p" separator="&#x20;"/>
                    </xsl:for-each>
                    <xsl:value-of select="$tab"/>

                    <!-- Provenance -->
                    <xsl:for-each select="ead:archdesc/ead:acqinfo">
                        <xsl:value-of select="ead:p" separator="&#x20;"/>
                    </xsl:for-each>
                    <xsl:value-of select="$tab"/>

                    <!-- Get all the subject, name, and place name headings and separate with semicolons -->

                    <!-- Topical Subjects -->
                   <xsl:for-each select="ead:archdesc/ead:controlaccess">
                            <xsl:value-of select="ead:subject" separator="; "/>      
                   </xsl:for-each>
                    <xsl:value-of select="$tab"/>
                   
                   <!-- Names -->
                   <xsl:for-each select="ead:archdesc/ead:controlaccess">
                       <xsl:value-of select="ead:persname | ead:corpname | ead:famname" separator="; "/>
                   </xsl:for-each>
                   <xsl:value-of select="$tab"/>
                    
                   <!-- Geographic Headings -->
                    <xsl:for-each select="ead:archdesc/ead:controlaccess">
                        <xsl:value-of select="ead:geogname" separator="; "/>
                    </xsl:for-each>
                    <xsl:value-of select="$tab"/>

                    <!-- ASpace refID for Archival Object record -->
                    <xsl:value-of select="//ead:c01[1]/@id"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Finding Aid URI -->
                    <xsl:value-of select="ead:eadheader/ead:eadid/@url"/>
                    <xsl:value-of select="$tab"/>

                </xsl:for-each>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
