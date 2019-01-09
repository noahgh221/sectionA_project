<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="urn:isbn:1-931666-22-9" exclude-result-prefixes="ead">

    <xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
    
    <!-- Call document seca-from-googlesheet.xml.  
        This is the XML export of the SecA "working" Google sheet
        The XML is used to access rights statements based on Aleph numbers -->
    
    <xsl:variable name="seca-googlesheet"
        select="document('seca-from-googlesheet.xml')"/>

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
         
            <xsl:text>title</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <xsl:text>creator</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>date_expression</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>date</xsl:text>
            <xsl:value-of select="$tab"/> 
            
            <xsl:text>language</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <xsl:text>extent</xsl:text>
            <xsl:value-of select="$tab"/>

            <!-- not needed
            <xsl:text>physical_description</xsl:text>
            <xsl:value-of select="$tab"/>
            -->

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
            
            <xsl:text>type</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <xsl:text>collection_slug</xsl:text>
            <xsl:value-of select="$tab"/>

            <xsl:text>aleph_id</xsl:text>
            <xsl:value-of select="$tab"/>

            <!-- REMOVED ASPACE_ID, FINDING_AID_URL, AND IDENTIFIER FIELDS -
                NO LONGER NEEDED IF NOT CREATING FINDING AIDS OR ASPACE RECORDS AS OF 1/9/2018 -->
            
            <!-- <xsl:text>aspace_id</xsl:text>
            <xsl:value-of select="$tab"/> -->
            
            <!-- Not needed for DDR, but used for batch updating MARC with 856 links
            <xsl:text>finding_aid_url</xsl:text>
            <xsl:value-of select="$tab"/>   -->
            
            <!-- Not needed for DDR, but used for batch updating MARC with 856 links -->
            <xsl:text>oclc_num</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <!-- RL  Number mapped to identifier in DDR
            <xsl:text>identifier</xsl:text>
            <xsl:value-of select="$tab"/>
            -->

            <!-- Empty column, to be supplied by DPC -->
            <xsl:text>local_id</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <!-- Display format required by DDR -->
            <xsl:text>display_format</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <!-- Rights - to old rightsstatement.org URI -->
            <xsl:text>rights</xsl:text>
            <xsl:value-of select="$tab"/>
            
            <!-- Rights-note - a placeholder column for any explanatory note about rights URI -->
            <xsl:text>rights_note</xsl:text>
            
            
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
                    
                    <!-- Collection title -->
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:unittitle)"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Collection creator -->
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:origination)"/>
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
                        select="replace(normalize-space(ead:archdesc/ead:did/ead:physdesc/ead:extent),'^1 items','1 item')"/>
                    <xsl:value-of select="$tab"/>

                    <!-- Physdesc - any other kind of physical description if present
                    <xsl:value-of
                        select="normalize-space(ead:archdesc/ead:did/ead:physdesc[not(ead:extent)])"/>
                    <xsl:value-of select="$tab"/> 
                    -->

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
                            <xsl:value-of select="ead:subject|ead:persname|ead:corpname|ead:famname|ead:geogname" separator="| "/>      
                   </xsl:for-each>
                   <xsl:value-of select="$tab"/>
                   
                    <!-- Spatial Terms (by using first term in 651 heading). This works, but results in some dupe headings.  Not sure how to fix -->
                    <xsl:value-of select="distinct-values(ead:archdesc/ead:controlaccess/ead:geogname/tokenize(., ' -- ')[1])" separator="| "/>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- Format Headings (aat) -->
                    <xsl:value-of select="ead:archdesc/ead:controlaccess/ead:genreform" separator="| "/>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- DCMI Type - hard-coded to Text-->
                    <xsl:text>Text</xsl:text>
                    <xsl:value-of select="$tab"/>
                                        
                    <!-- EADID -->
                    <xsl:value-of select="ead:eadheader/ead:eadid"/>
                    <xsl:value-of select="$tab"/>

                     <!-- Aleph ID -->
                    <xsl:value-of select="//ead:num[@type='aleph']"/>
                    <xsl:value-of select="$tab"/>
                    
                    
                    <!-- ASpace refID for Archival Object record
                    <xsl:value-of select="//ead:c01[1]/@id"/>
                    <xsl:value-of select="$tab"/> -->
                                    
                    <!-- Finding Aid URL
                    <xsl:value-of select="ead:eadheader/ead:eadid/@url"/>
                    <xsl:value-of select="$tab"/>
                    -->
                    
                    
                    <!-- OCLC Number -->
                    <xsl:value-of select="//ead:num[@type='oclc']"/>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- RL Number (collection number)
                    <xsl:value-of select="ead:archdesc/ead:did/ead:unitid"/>
                    <xsl:value-of select="$tab"/>
                    -->
                    
                    <!-- DPC_ID: Empty column -->
                    <xsl:text>[local_id]</xsl:text>
                    <xsl:value-of select="$tab"/>
                    
                    <!-- Display format - hard-coded to 'image' for DDR -->
                    <xsl:text>image</xsl:text>
                    <xsl:value-of select="$tab"/>
                                        
                    <!-- Rights URI from rightsstatement.org - get this from Google Sheet? -->
                    <!-- <xsl:text>[rights_uri]</xsl:text> -->
                               <!-- local variable for storing eadid string in source xml document -->
                    <xsl:variable name="aleph_number_from_ead" select="//ead:num[@type='aleph']"/>    
                    <xsl:for-each select="$seca-googlesheet//data/*"> 
                        <!-- iterate through each spreadsheet row element in XML-->
                        <xsl:if test="AlephNumber=$aleph_number_from_ead">
                            <xsl:value-of select="Rights_Statement"/>       
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:value-of select="$tab"/>
                                        
                    <!-- Rights note - an explanatory note refining rights URI -->
                    <xsl:text>[rights_note]</xsl:text>
                    <xsl:value-of select="$tab"/>
                    
                </xsl:for-each>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
