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

            <xsl:text>container_1</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>creator</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>title</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>date_expression</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>date</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>language</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <xsl:text>extent</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>physical_description</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>description</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>provenance</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>subject</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>spatial</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <xsl:text>format</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <xsl:text>ead_id</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>aspace_id</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <xsl:text>finding_aid_url</xsl:text>
            <xsl:value-of select="$tab"/>            

            <!-- Empty column, to be supplied after URI is established, ARKs? -->
            <xsl:text>dpc_id</xsl:text>


            <!-- BEGIN DATA ROWS -->
            <!-- !!!Process all EADs in a subfolder (e.g. seca_001) -->
            <!-- Store the parent directory of EAD files as a variable to pass into collection function -->
            <xsl:variable name="ead_directory_name_path">
                <xsl:value-of select="concat('file:/C:/users/nh48/documents/github/sectionA_project/ead/',$box_number,'/?select=*.xml')"/>
            </xsl:variable>
            
            <xsl:for-each
                select="collection($ead_directory_name_path)">

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
                    
                    <!-- Language code -->
                    <xsl:value-of select="ead:archdesc/ead:did/ead:langmaterial/ead:language/@langcode"/>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- Extent - controlled extent statement, typically # of items or pages -->
                    <xsl:value-of
                        select="normalize-space(ead:archdesc/ead:did/ead:physdesc/ead:extent)"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Physdesc - any other kind of physical description if present -->
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

                    <!-- Topical Subjects and Name Headings. Also include full geographic headings (have lots of subdivisions) -->
                   <xsl:for-each select="ead:archdesc/ead:controlaccess">
                            <xsl:value-of select="ead:subject|ead:persname|ead:corpname|ead:famname|ead:geogname" separator="; "/>      
                   </xsl:for-each>
                   <xsl:value-of select="$tab"/>
                   
                    <!-- Spatial Terms (by using first term in 651 heading). This works, but results in some dupe headings.  Not sure how to fix -->
                    <xsl:value-of select="distinct-values(ead:archdesc/ead:controlaccess/ead:geogname/tokenize(., ' -- ')[1])" separator="; "/>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- Format Headings (aat) -->
                    <xsl:value-of select="ead:archdesc/ead:controlaccess/ead:genreform" separator="; "/>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- EADID -->
                    <xsl:value-of select="ead:eadheader/ead:eadid"/>
                    <xsl:value-of select="$tab"/>

                    <!-- ASpace refID for Archival Object record -->
                    <xsl:value-of select="//ead:c01[1]/@id"/>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- Finding Aid URI -->
                    <xsl:value-of select="ead:eadheader/ead:eadid/@url"/>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- DPC_ID: Empty column -->
                    <xsl:text>dpc_id</xsl:text>

                </xsl:for-each>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
