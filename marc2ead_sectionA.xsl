<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:marc="http://www.loc.gov/MARC21/slim"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="3.0" exclude-result-prefixes="marc uuid"
  xmlns:uuid="java.util.UUID"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon">

  <!-- Created by Noah Huffman, Duke University -->
  <!-- LAST UPDATED by Noah Huffman, December 2016, for use with converting Section A MARC records to Stub EADs for import to ArchivesSpace -->
  <!-- This XSLT has evolved over many projects and should probalby be rewritten entirely...but let's just go with it. -->
  <!-- For use with accompanying stylesheet MARC21slimUtils.xsl, provided with MARCEdit -->
  <!-- Converts MARC records for Section A collections (single-folder collections) to basic EAD finding aids suitable for import into ArchivesSpace. -->
  
<xsl:import href="MARC21slimUtils.xsl"/>

<xsl:output indent="no" method="text" encoding="UTF-8"/>

<!-- NEED TO ADJUST @SELECT FOR EVERY NEW BATCH. Find the last used RL number in ASpace and put below, will use next number -->
<xsl:variable name="RLID" select="30017" saxon:assignable="yes"/>
 
<!-- Variables for outputing digitization guide as TSV file.     Currently using a separate XSLT for creating the digguide-->

<xsl:variable name="tab"><xsl:text>&#009;</xsl:text></xsl:variable>
<xsl:variable name="newline"><xsl:text>&#xa;</xsl:text></xsl:variable>

 
<xsl:template match="marc:record">
 
<!-- CHANGE NAME VARIABLE AS NEEDED -->
<xsl:variable name="ProcessorName" select="'Rubenstein Staff'"/>
<xsl:variable name="EncoderName" select="'Noah Huffman'"/>

<!-- Processing and Encoding Dates from MARC 005 - Date record was exported -->
<!--
<xsl:variable name="Year" select="substring(marc:controlfield[@tag='005'],1,4)"/>
<xsl:variable name="MM" select="substring(marc:controlfield[@tag='005'],5,2)"/> 
<xsl:variable name="Month">
<xsl:choose>
      <xsl:when test="$MM = '01'">January</xsl:when>
      <xsl:when test="$MM = '02'">February</xsl:when>
      <xsl:when test="$MM = '03'">March</xsl:when>
      <xsl:when test="$MM = '04'">April</xsl:when>
      <xsl:when test="$MM = '05'">May</xsl:when>
      <xsl:when test="$MM = '06'">June</xsl:when>
      <xsl:when test="$MM = '07'">July</xsl:when>
      <xsl:when test="$MM = '08'">August</xsl:when>
      <xsl:when test="$MM = '09'">September</xsl:when>
      <xsl:when test="$MM = '10'">October</xsl:when>
      <xsl:when test="$MM = '11'">November</xsl:when>
      <xsl:when test="$MM = '12'">December</xsl:when>
</xsl:choose>
</xsl:variable>
-->
  
<!-- Hardcoded Date variable use in place of above, change as needed-->
<xsl:variable name="Year" select="'2017'"/>
<xsl:variable name="Month" select="'January'"/>


<!-- LANGUAGE VARIABLES Add more as needed-->
<xsl:variable name="LangCode" select="substring(marc:controlfield[@tag='008'],36,3)"/>
<xsl:variable name="Language">
<xsl:choose>
      <xsl:when test="$LangCode = 'eng'">English</xsl:when>
      <xsl:when test="$LangCode = 'ger'">German</xsl:when>
      <xsl:when test="$LangCode = 'fre'">French</xsl:when>
      <xsl:when test="$LangCode = 'spa'">Spanish</xsl:when>
      <xsl:when test="$LangCode = 'ita'">Italian</xsl:when>
      <xsl:when test="$LangCode = 'jpn'">Japanese</xsl:when>
      <xsl:when test="$LangCode = 'chi'">Chinese</xsl:when>
	  <xsl:when test="$LangCode = 'lat'">Latin</xsl:when>
	  <xsl:when test="$LangCode = 'dan'">Danish</xsl:when>
      <xsl:when test="$LangCode = 'ice'">Icelandic</xsl:when>
      <xsl:when test="$LangCode = 'gre'">Greek</xsl:when>
      <xsl:when test="$LangCode = 'dut'">Dutch</xsl:when>
      <xsl:otherwise>LANGUAGE?</xsl:otherwise>
</xsl:choose>
</xsl:variable>
  
 
<!-- EADID variable for filename, EADID, and URL string -->
  
  <xsl:variable name="EADID">
  <xsl:choose>
    <xsl:when test="marc:datafield[@tag='100']/marc:subfield [@code='a' and not(@code='k')] | marc:datafield[@tag='110']/marc:subfield [@code='a'] and not(@code='k')">
     
      
      <xsl:value-of select='lower-case(translate(marc:datafield[@tag="100"]/marc:subfield [@code="a"] | marc:datafield[@tag="110"]/marc:subfield [@code="a"],":[]&apos;-()1234567890.?!, ",""))'/>
      <xsl:value-of select='lower-case(translate(marc:datafield[@tag="110"]/marc:subfield [@code="b"][1],":[]&apos;-()1234567890.?!,; ",""))'/>
      <!-- conditions to prevent duplicate EADIDs and filename -->
      <xsl:if test="contains(marc:datafield[@tag='245'], 'letters')">
        <xsl:text>letters</xsl:text>
      </xsl:if>
      <xsl:if test="contains(marc:datafield[@tag='245'], 'papers')">
        <xsl:text>papers</xsl:text>
      </xsl:if>
      <xsl:if test="contains(marc:datafield[@tag='245'], 'document')">
        <xsl:text>document</xsl:text>
      </xsl:if>
    </xsl:when>
    
    <xsl:when test="marc:datafield[@tag='100']/marc:subfield [@code='k'] | marc:datafield[@tag='110']/marc:subfield [@code='k']">
     
      
      <xsl:value-of select='lower-case(translate(marc:datafield[@tag="100"]/marc:subfield [@code="k"][1] | marc:datafield[@tag="110"]/marc:subfield [@code="k"][1],":[]&apos;-()1234567890.?!, ",""))'/>
      <xsl:value-of select='lower-case(translate(marc:datafield[@tag="110"]/marc:subfield [@code="b"][1],":[]&apos;-()1234567890.?!,; ",""))'/>
      <!-- conditions to prevent duplicate EADIDs and filename -->
      <xsl:if test="contains(marc:datafield[@tag='245'], 'letters')">
        <xsl:text>letters</xsl:text>
      </xsl:if>
      <xsl:if test="contains(marc:datafield[@tag='245'], 'papers')">
        <xsl:text>papers</xsl:text>
      </xsl:if>
      <xsl:if test="contains(marc:datafield[@tag='245'], 'document')">
        <xsl:text>document</xsl:text>
      </xsl:if>
    </xsl:when>
    
    
    
    <!-- If no 1xx field, but 245 present, then use title string -->
    <xsl:when test="not(marc:datafield[@tag='100'] | marc:datafield[@tag='110']) and marc:datafield[@tag='245'][marc:subfield [@code='a']]">
     <xsl:value-of select='lower-case(translate(marc:datafield[@tag="245"]/marc:subfield [@code="a"],":[]&apos;-()1234567890.,?!; ",""))'/>
    </xsl:when>
    
    <xsl:when test="not(marc:datafield[@tag='100'] | marc:datafield[@tag='110']) and marc:datafield[@tag='245'][marc:subfield [@code='k']]">
      <xsl:value-of select='lower-case(translate(marc:datafield[@tag="245"]/marc:subfield [@code="k"][1],"[]:&apos;-()1234567890.,?!; ",""))'/>
    </xsl:when>
    
    <!--If no 001 field, then apend zzz and 005 field to sort these at bottom for cleanup -->
    <xsl:when test="not(marc:controlfield[@tag='001'])">
      <text>zzz-</text><xsl:value-of select="marc:controlfield[@tag='005']"/>
    </xsl:when>
    
    <xsl:otherwise>
      <xsl:text>zzz-</xsl:text><xsl:value-of select="marc:controlfield[@tag='001']"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
  
 <!-- EADID for filename: removes diacritics from EADID and appends Aleph number to avoid possible 1xx duplicates. Not sure how removing diacritics works. See: http://www.stylusstudio.com/xquerytalk/201106/003547.html -->  
<xsl:variable name="EADID_unique">
  <xsl:value-of select="translate(replace(normalize-unicode($EADID,'NFKD'),'[\p{M}]',''), 'đʹ&amp;','d')"/>
 <!-- Include Aleph system number in filename to guarantee uniqueness -->
  <xsl:text>-</xsl:text><xsl:value-of select="marc:controlfield[@tag='001']"/>
</xsl:variable>


<!-- END EADID Variables -->


<!-- Collection Title Variable. Regex replaces trailing comma before $f date-->
  <xsl:variable name="CollectionTitle">
    <xsl:choose>
      <xsl:when test="marc:datafield[@tag='245']/marc:subfield [@code='a']">
        <xsl:value-of select="normalize-space(marc:datafield[@tag='245']/marc:subfield [@code='a'])"/>
      </xsl:when>
      <xsl:when test="marc:datafield[@tag='245']/marc:subfield[@code='k'][not(@code='a')]">
        <xsl:value-of select="normalize-space(marc:datafield[@tag='245']/marc:subfield [@code='k'][1])"/>
      </xsl:when>
    </xsl:choose>
    
  </xsl:variable>
 
 
 <!-- Output full collection titles with dates and subtitles as collection guide title -->
  <xsl:variable name="FindingAidTitle" select="marc:datafield[@tag='245']//*/text()"/>
  
<!-- Collection Normal Date Variables -->

  <xsl:variable name="CollectionNormalStartDateTest" select="substring(marc:controlfield[@tag='008'],8,4)"/>
 <!-- For Start dates, test for various ambiguous dates in MARC fixed fields and correct (e.g. 19uu = 1900) -->
  <xsl:variable name="CollectionNormalStartDate">
    <xsl:choose>
      <xsl:when test="$CollectionNormalStartDateTest = '    '"><xsl:text>uuuu</xsl:text></xsl:when>
      <xsl:when test="$CollectionNormalStartDateTest = 'n.d.'"><xsl:text>uuuu</xsl:text></xsl:when> <!-- WTF?  why is there n.d. in 008? -->
      <xsl:when test="matches($CollectionNormalStartDateTest,'(\d\d\d)u')"><xsl:value-of select="replace($CollectionNormalStartDateTest,'(\d\d\d)u','$10')"/></xsl:when>
      <xsl:when test="matches($CollectionNormalStartDateTest,'(\d\d)uu')"><xsl:value-of select="replace($CollectionNormalStartDateTest,'(\d\d)uu','$100')"/></xsl:when> 
      <xsl:otherwise><xsl:value-of select="$CollectionNormalStartDateTest"/></xsl:otherwise>
    </xsl:choose>   
 </xsl:variable>

<xsl:variable name="CollectionNormalEndDateTest" select="substring(marc:controlfield[@tag='008'],12,4)"/>
 <!-- For End dates, test for various ambiguous dates in MARC fixed fields and correct (e.g. 19uu = 1999) -->
<xsl:variable name="CollectionNormalEndDate">
<xsl:choose>
  <xsl:when test="$CollectionNormalEndDateTest = '    '"><xsl:value-of select="$CollectionNormalStartDate"/></xsl:when> <!-- for single dates, repeats start date as end date -->
  <xsl:when test="$CollectionNormalEndDateTest = 'n.d.'"><xsl:text>uuuu</xsl:text></xsl:when>
  <xsl:when test="$CollectionNormalEndDateTest = 'uuuu'"><xsl:value-of select="$CollectionNormalStartDate"/></xsl:when>
  <xsl:when test="matches($CollectionNormalEndDateTest,'(\d\d\d)u')"><xsl:value-of select="replace($CollectionNormalEndDateTest,'(\d\d\d)u','$19')"/></xsl:when>
  <xsl:when test="matches($CollectionNormalEndDateTest,'(\d\d)uu')"><xsl:value-of select="replace($CollectionNormalEndDateTest,'(\d\d)uu','$199')"/></xsl:when>
  <xsl:otherwise><xsl:value-of select="$CollectionNormalEndDateTest"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--Collection Date Expression Variable , remove trailing semicolon -->
<xsl:variable name="CollectionDate1" select="normalize-space(replace(marc:datafield[@tag='245']/marc:subfield [@code='f'], ':$',''))"/>

<!-- Collection Date - remove terminal period unless ends in two word characters (e.g. Apr.) -->
<xsl:variable name="CollectionDate">
  <xsl:choose>
    <xsl:when test="matches($CollectionDate1,',$')">
      <xsl:value-of select="replace($CollectionDate1,',$','')"/>
    </xsl:when>
    <xsl:when test="matches($CollectionDate1,'\d\d\.$')">
      <xsl:value-of select="replace($CollectionDate1,'\.$','')"/>
    </xsl:when>  
    <xsl:when test="matches($CollectionDate1,'\w\w\.$')">
      <xsl:value-of select="$CollectionDate1"/>
    </xsl:when>           
    <xsl:otherwise>
      <xsl:value-of select="$CollectionDate1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>


<!-- BEGIN EAD DOCUMENT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<!-- save EADs in subfolders based on box number from input marcxml filename (e.g. seca_001.xml) -->
<xsl:variable name="box_number">
  <xsl:value-of select="replace(tokenize(base-uri(), '/')[last()],'.xml','')"/>
</xsl:variable>

<xsl:result-document method="xml" indent="yes" href="file:/C:/users/nh48/documents/github/sectionA_project/ead/{$box_number}/{$EADID_unique}.xml">
    
<ead xmlns="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd">

<eadheader findaidstatus="SecA_record" countryencoding="iso3166-1" dateencoding="iso8601" langencoding="iso639-2b" repositoryencoding="iso15511">
  <eadid countrycode="US" mainagencycode="US-NcD" publicid="-//David M. Rubenstein Rare Book &amp; Manuscript Library//TEXT (US::NcD::{$CollectionTitle} {$CollectionDate} //EN" url="http://library.duke.edu/rubenstein/findingaids/{$EADID_unique}/"><xsl:value-of select="$EADID_unique"/></eadid>

<filedesc>
<titlestmt>
  <titleproper>Guide to the <xsl:value-of select="replace($CollectionTitle,'letter','Letter')"/><xsl:text> </xsl:text><xsl:value-of select="$CollectionDate"/>
  <xsl:if test="marc:datafield[@tag='245']/marc:subfield[@code='b']">
    <xsl:text>, </xsl:text>
    <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='245']/marc:subfield[@code='b'],'\.$',''))"></xsl:value-of>
  </xsl:if>
  </titleproper>
  <author>Processed by: <xsl:value-of select="$ProcessorName"/>; EAD finding aid derived from MARC record using marc2ead_sectionA.xsl</author>
</titlestmt>

<!-- Unnecessary for ASpace import; this info is supplied by Repository record
<publicationstmt>
  <publisher>David M. Rubenstein Rare Book &amp; Manuscript Library.</publisher>
  <address>
    <addressline>Duke University</addressline>
    <addressline>Durham, NC 27708 U.S.A.</addressline>
    <addressline>919-660-5822</addressline>
    <addressline>special-collections@duke.edu</addressline>
  </address>
  <date normal="{$Year}" encodinganalog="date"><xsl:value-of select="$Year"/></date>
</publicationstmt>
  -->

<!-- Insert Aleph Number -->
<notestmt>
  <note>
    <p>Aleph Number: <num type="aleph"><xsl:value-of select="marc:controlfield[@tag='001']"/></num></p>
    <p>OCLC Number: <num type="oclc"><xsl:value-of select="normalize-space(marc:datafield[@tag='035'])"/></num></p>
  </note>
</notestmt>
</filedesc>

<profiledesc>
  <creation>Finding aid derived from MARC record via marc2ead_sectionA.xsl, <date>2017</date></creation>
  <langusage>English</langusage>
  <descrules>Describing Archives: A Content Standard</descrules>
 </profiledesc>
  
</eadheader>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<!-- ARCHDESC -->
<archdesc level="collection">
<did>
  <repository label="Repository"><corpname>David M. Rubenstein Rare Book &amp; Manuscript Library, Duke University</corpname></repository>
     
  <!-- local variable for storing Alephnum string in source xml document -->
  <xsl:variable name="alephnum_string" select="marc:controlfield[@tag='001']"/>

<!--NEED TO SUPPLY A COLLECTION NUMBER!!-->
    <!-- <unitid><xsl:value-of select="$EADID_for_filename"/></unitid> -->
 
<!-- Increment RLID values, will need to modify starting RLID for each input MARCXML file. -->
  <saxon:assign name="RLID" select="$RLID+1"/>
  <unitid>RL.<xsl:value-of select="$RLID"/></unitid>
     
<!-- CREATOR INFO -->
      <xsl:choose>
        
        <xsl:when test="marc:datafield[@tag='110']">
              <origination label="Creator">
                <corpname encodinganalog="110" source="lcnaf">                
                  <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='110']/marc:subfield[@code='a'],',$',''))"/>
                  <xsl:for-each select="marc:datafield[@tag='110']/marc:subfield[@code='b']">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
                  </xsl:for-each>
                </corpname>
              </origination>
            </xsl:when>
            
        <xsl:when test="marc:datafield[@tag='100']">
              <origination label="Creator">
                <persname encodinganalog="100" source="lcnaf">
                  
         <xsl:choose>
                    <xsl:when test="marc:datafield[@tag='100']/marc:subfield[@code='e'] and not(marc:datafield[@tag='100']/marc:subfield[@code='d'] or marc:datafield[@tag='100']/marc:subfield[@code='c'])">
                    <xsl:value-of select="replace(normalize-space(marc:datafield[@tag='100']/marc:subfield[@code='a']),',$','')"/>
                    </xsl:when>
                                        
                    <xsl:otherwise>
                      <!-- OMG. This removes period from end of $a if there are three word charaters followed by a period. Such a hack. -->
                      <xsl:value-of select="replace(normalize-space(marc:datafield[@tag='100']/marc:subfield[@code='a']),'(\w{3})\.$','$1')"/>
                    </xsl:otherwise>
          </xsl:choose>
                  
                  
          <xsl:for-each select="marc:datafield[@tag='100']/marc:subfield[@code='q']">
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(.)"/>
				  </xsl:for-each>
          
          <xsl:if test="marc:datafield[@tag='100']/marc:subfield[@code='b']">
            <xsl:text> </xsl:text>
            <xsl:value-of select="marc:datafield[@tag='100']/marc:subfield[@code='b']"/>
          </xsl:if>
          
          <xsl:if test="marc:datafield[@tag='100']/marc:subfield[@code='c']">
          <xsl:text> </xsl:text><xsl:value-of select="normalize-space(replace(marc:datafield[@tag='100']/marc:subfield[@code='c'],'(\w{3})\.$','$1'))"/>
          </xsl:if>        
          
         <!-- deal with those trailing commas and period situations... -->
          <xsl:if test="marc:datafield[@tag='100']/marc:subfield[@code='d'] and not(marc:datafield[@tag='100']/marc:subfield[@code='e'])">
					<xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='100']/marc:subfield[@code='d'],'\.$',''))"/>
				  </xsl:if>
                  
                  <xsl:if test="marc:datafield[@tag='100']/marc:subfield[@code='d'] and marc:datafield[@tag='100']/marc:subfield[@code='e']">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='100']/marc:subfield[@code='d'],',$',''))"/>
                  </xsl:if>
                </persname>
              </origination>
            </xsl:when>
          </xsl:choose>

	<!-- TITLE INFO without date -->

          <unittitle label="Title" encodinganalog="245">
            <xsl:value-of select="replace($CollectionTitle,',$','')"/>
            
            <!-- to account for 245$a that ends with : do not add comma -->
            <xsl:if test="marc:datafield[@tag='245']/marc:subfield [@code='b'] and not(ends-with($CollectionTitle, ':'))">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='245']/marc:subfield [@code='b'],'\.$',''))"/>
            </xsl:if>
          
            <xsl:if test="marc:datafield[@tag='245']/marc:subfield [@code='b'] and ends-with($CollectionTitle, ':')">
              <xsl:text> </xsl:text>
              <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='245']/marc:subfield [@code='b'],'\.$',''))"/>
            </xsl:if>

          </unittitle>
  
<!-- Date info -->  
       
     <xsl:choose>
       <!-- Exclude normal attribute on unitdate when uuuu dates present -->
       <xsl:when test="$CollectionNormalEndDate='uuuu' or contains($CollectionNormalStartDate,'?')"> 
       <unitdate type="inclusive" era="ce" calendar="gregorian">
       <xsl:value-of select="$CollectionDate"/>
       </unitdate>
       </xsl:when>
       
       <xsl:otherwise>
         <unitdate normal="{$CollectionNormalStartDate}/{$CollectionNormalEndDate}" type="inclusive" era="ce" calendar="gregorian">
           <xsl:value-of select="$CollectionDate"/>
       </unitdate>
       </xsl:otherwise>
     </xsl:choose> 
 
          
<!-- LANGUAGE -->  

<langmaterial>
  <language langcode="{$LangCode}"/>
</langmaterial>        

<langmaterial label="Language of Materials">Materials in <xsl:value-of select="$Language"/></langmaterial>
 
<!-- EXTENT -->

<!-- Need to munge extent value to produce one statement with number and type and one with anything in parens 
  Most statements look like this 20 items (0.7 linear ft.)-->
  
<!-- Use 'Extent: ' prefix to prevent creating unnecessary extent types? -->

  <xsl:variable name="extent_string">
    <xsl:value-of select="marc:datafield[@tag='300'][1]//text()"/>
  </xsl:variable>

<!-- OLD VERSION 
<xsl:variable name="extent_string">
  <xsl:value-of select="concat(marc:datafield[@tag='300'][1]/marc:subfield[@code='a'][1], marc:datafield[@tag='300'][1]/marc:subfield[@code='c'][1], marc:datafield[@tag='300'][1]/marc:subfield[@code='f'][1])"/>
</xsl:variable>
-->

<xsl:choose>

  <xsl:when test="contains($extent_string, 'lin') and contains($extent_string, ')')">
  <physdesc>
    <extent><xsl:value-of select="replace(normalize-space(substring-before(substring-after($extent_string, '('), 'lin')),'^\.','0.')"/><xsl:text> linear feet</xsl:text></extent>
  </physdesc>
  </xsl:when>
  
  <xsl:when test="contains($extent_string, 'lin') and not(contains($extent_string, ')'))">
    <physdesc>
      <extent><xsl:value-of select="replace(normalize-space(substring-before($extent_string, 'lin')),'^\.','0.')"/><xsl:text> linear feet</xsl:text></extent>
    </physdesc>
  </xsl:when>
  
<xsl:when test="contains($extent_string, 'items') and not(contains($extent_string, 'lin'))">
  <physdesc>
    <extent><xsl:value-of select="normalize-space(translate(substring-before($extent_string,'items'), ',',''))"/><xsl:text> items</xsl:text></extent>
  </physdesc>
</xsl:when>
  
  <xsl:when test="contains($extent_string, 'item') and not(contains($extent_string, 'lin')) and not(contains($extent_string, 'items'))">
    <physdesc>
      <extent><xsl:value-of select="normalize-space(translate(substring-before($extent_string,'item'), ',',''))"/><xsl:text> item</xsl:text></extent>
    </physdesc>
  </xsl:when>

  <xsl:when test="contains($extent_string, 'v.') and not(contains($extent_string, 'lin')) and not(contains($extent_string, 'items'))">
    <physdesc>
      <extent><xsl:value-of select="normalize-space(translate(substring-before($extent_string,'v.'), ',',''))"/><xsl:text> volumes</xsl:text></extent>
    </physdesc>
  </xsl:when>
  
  <xsl:when test="contains($extent_string, 'vol.') and not(contains($extent_string, 'lin')) and not(contains($extent_string, 'items'))">
    <physdesc>
      <extent><xsl:value-of select="normalize-space(translate(substring-before($extent_string,'vol.'), ',',''))"/><xsl:text> volumes</xsl:text></extent>
    </physdesc>
  </xsl:when>
  
  <xsl:when test="contains($extent_string, 'vols.') and not(contains($extent_string, 'lin')) and not(contains($extent_string, 'items'))">
    <physdesc>
      <extent><xsl:value-of select="normalize-space(translate(substring-before($extent_string,'vols.'), ',',''))"/><xsl:text> volumes</xsl:text></extent>
    </physdesc>
  </xsl:when>
  
  <!-- Supply some garbage extent data for MARC records with no 300 field 
  Will need to clean these up later-->
  <xsl:when test="not(marc:datafield[@tag='300'])">
    <physdesc>
      <extent>9999 fake_extent_units</extent>
    </physdesc>
  </xsl:when>
  
<xsl:otherwise>
  <physdesc>
    <extent><xsl:value-of select="normalize-space(replace(($extent_string),'^(\d+)(\w)','$1 $2'))"/></extent>
  </physdesc>
</xsl:otherwise>  

</xsl:choose> 
  
<!-- Old extent code
              <xsl:for-each select="marc:datafield[@tag='300']">
              <physdesc>
                <extent encodinganalog="300"><xsl:text>Extent: </xsl:text><xsl:value-of select="marc:subfield[@code='a']"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="replace(marc:subfield [@code='f'],'\.$','')"/> 
                </extent>
              </physdesc>
              </xsl:for-each>
 --> 
  
  
<!-- ABSTRACT -->
  
<!-- concat 545 and 520 into abstract
        <xsl:choose>
          <xsl:when test="marc:datafield[@tag='545']">
              <abstract label="Abstract">
                <xsl:value-of select="marc:datafield[@tag='545']"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="marc:datafield[@tag='520']">
                  <xsl:value-of select="."/>
                  <xsl:text> </xsl:text>
                </xsl:for-each>
              </abstract>
          </xsl:when>
          
          <xsl:otherwise>
              <abstract label="Abstract">
                <xsl:for-each select="marc:datafield[@tag='520']">
                  <xsl:value-of select="."/>
                  <xsl:text> </xsl:text>
                </xsl:for-each>
              </abstract>
            </xsl:otherwise>
        </xsl:choose>
 -->
  
 <!-- Use only MARC520 as abstract -->
  
 <xsl:if test="marc:datafield[@tag='520']">
  <abstract>
    <xsl:for-each select="marc:datafield[@tag='520']">
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:if test="marc:datafield[@tag='520'][2]"><xsl:text> </xsl:text></xsl:if>
    </xsl:for-each>
  </abstract>
</xsl:if>

</did>
        
<!-- ADMINISTRATIVE INFO -->


          
         <!-- Put any special Access Restrictions in their own field -->
          <xsl:if test="marc:datafield[@tag='506']">
              <xsl:for-each select="marc:datafield[@tag='506']">
                  <accessrestrict encodinganalog="506">
                  <head>Access Restrictions</head>
                  <p><xsl:value-of select="normalize-space(.)"/></p>
                  </accessrestrict>
              </xsl:for-each>
          </xsl:if>
              
              <!-- Boilerplate Restriction -->
          <accessrestrict encodinganalog="506">
              <head>Access Restrictions</head>
                <p>Collection is open for research.</p>
                <p>Researchers must register and agree to copyright and privacy laws before using this collection.</p>                
                <p>All or portions of this collection may be housed off-site in Duke University's Library Service Center. The library may require up to 48 hours to retrieve these materials for research use.</p>                
                <p>Please contact Research Services staff before visiting the Rubenstein to use this collection.</p>
          </accessrestrict>
          
          <xsl:if test="marc:datafield[@tag='530']">
            <altformavail encodinganalog="530">
              <head>Alternate Form of Material</head>
              <xsl:for-each select="marc:datafield[@tag='530']">
              <p><xsl:value-of select="normalize-space(.)"/></p>
              </xsl:for-each>
            </altformavail>
          </xsl:if>
   
   <!-- Boilerplate Use Resriction -->
  <userestrict encodinganalog="540">
    <head>Use Restrictions</head>
    <p>The copyright interests in this collection have not been transferred to Duke University. For more information, consult the copyright section of the Regulations and Procedures of the David M. Rubenstein Rare Book &amp; Manuscript Library.</p>
  </userestrict>

  <prefercite encodinganalog="524">
            <p><xsl:value-of select="replace($CollectionTitle,'papers','Papers')"/><xsl:text> </xsl:text><xsl:value-of select="$CollectionDate"/>
              <xsl:if test="marc:datafield[@tag='245']/marc:subfield[@code='b']">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='245']/marc:subfield[@code='b'],'\.$',''))"></xsl:value-of>
              </xsl:if>
              <xsl:text>, David M. Rubenstein Rare Book &amp; Manuscript Library, Duke University.</xsl:text></p>
  </prefercite>
          
          <xsl:if test="marc:datafield[@tag='541']">
            <acqinfo encodinganalog="541">
              <head>Provenance</head>
              <xsl:for-each select="marc:datafield[@tag='541']">
                <p><xsl:value-of select="normalize-space(replace(translate(.,'.',''), ';', ','))"/></p>
              </xsl:for-each>
            </acqinfo>
          </xsl:if>
          
          <processinfo>
            <p>Processed by: <xsl:value-of select="$ProcessorName"/></p>
            <p>This finding aid was derived from a MARC record using a crosswalk defined in marc2ead_section.xsl. The finding aid was generated as part of a larger project to digitize several thousand small collections housed in Section A, <xsl:value-of select="$Month"/><xsl:text> </xsl:text><xsl:value-of select="$Year"/>.</p>
          </processinfo>
        
<!-- BIOGRAPHICAL NOTE -->
<xsl:if test="marc:datafield[@tag='545']">
          <bioghist>
            <head>Historical Note</head>
            <xsl:for-each select="marc:datafield[@tag='545']">
            <p><xsl:value-of select="normalize-space(.)"/></p>
            </xsl:for-each>
          </bioghist>
        </xsl:if>
        
<!-- COLLECTION OVERVIEW -->
  <xsl:if test="marc:datafield[@tag='520']">      
  <scopecontent>
          <head>Collection Overview</head>
          <xsl:for-each select="marc:datafield[@tag='520']">
            <p><xsl:value-of select="normalize-space(.)"/></p>
          </xsl:for-each>
        </scopecontent>
  </xsl:if>
  
  <!-- Generic 500 note -->
  <xsl:if test="marc:datafield[@tag='500']">
     <xsl:for-each select="marc:datafield[@tag='500']">
        <odd>
          <p><xsl:value-of select="normalize-space(.)"/></p>
        </odd>
      </xsl:for-each>
   </xsl:if>
  
<!-- ARRANGEMENT -->
        <xsl:if test="marc:datafield[@tag='351']">
          <arrangement encodinganalog="351">
            <xsl:for-each select="marc:datafield[@tag='351']/marc:subfield">
              <p><xsl:value-of select="normalize-space(.)"/></p>
            </xsl:for-each>
          </arrangement>
        </xsl:if>
        
        
<!-- ONLINE CATALOG HEADINGS -->


  <xsl:if test="marc:datafield[@tag='600'] | marc:datafield[@tag='610'] | marc:datafield[@tag='650'] | marc:datafield[@tag='655'] | marc:datafield[@tag='611'] | marc:datafield[@tag='651'] | marc:datafield[@tag='700'] | marc:datafield[@tag='710']">
  <controlaccess>
          <!-- TOPICAL SUBJECTS -->
          
          <!-- MESH Topics -->
          <xsl:if test="marc:datafield[@tag='650'][@ind2='2']">
            <xsl:for-each select="marc:datafield[@tag='650'][@ind2='2']">
                <subject source="mesh" encodinganalog="650">
                    <xsl:value-of select="normalize-space(replace(marc:subfield[@code='a'],'\.$',''))"/>
                    <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                      <xsl:text> -- </xsl:text>
                      <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
                    </xsl:for-each>
                  </subject>
              </xsl:for-each>
            </xsl:if>
          
          <!-- LCSH Topics -->
          <xsl:if test="marc:datafield[@tag='650'][@ind2='0']">
          <xsl:for-each select="marc:datafield[@tag='650'][@ind2='0']">
            <subject source="lcsh" encodinganalog="650">
              <xsl:value-of select="normalize-space(replace(marc:subfield[@code='a'],'\.$',''))"/>
              <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                <xsl:text> -- </xsl:text>
                <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
              </xsl:for-each>
            </subject>
          </xsl:for-each>
          </xsl:if>
            
            
          <!-- LCNAF Names -->  
    <xsl:if test="marc:datafield[@tag='600'][@ind1='1'][@ind2='0'] | marc:datafield[@tag='700'][@ind1='1']">
      <xsl:for-each select="marc:datafield[@tag='600'][@ind1='1'][@ind2='0'] | marc:datafield[@tag='700'][@ind1='1']">
             
        <xsl:sort select="marc:subfield[@code='a']"/>
             
        <xsl:choose>
                  <xsl:when test="@tag='600'">
                  
                      <persname source="lcnaf" encodinganalog="600">
     
                        <xsl:value-of select="replace(normalize-space(marc:subfield[@code='a']),'(\w{2})\.$','$1')"/>
                                                
                        <xsl:if test="marc:subfield[@code='b']">
                          <xsl:value-of select="normalize-space(marc:subfield[@code='b'])"/>
                        </xsl:if>
                                       
                        <xsl:if test="marc:subfield[@code='q']">
                          <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(marc:subfield[@code='q'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='c']">
                          <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(marc:subfield[@code='c'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='d']">
                        <xsl:text> </xsl:text>
                          <xsl:value-of select="normalize-space(replace(marc:subfield[@code='d'],'\.$',''))"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='e']">
                        <xsl:value-of select="normalize-space(marc:subfield[@code='e'])"/>
                        </xsl:if>
                        
                        <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                          <xsl:text> -- </xsl:text>
                          <xsl:value-of select="normalize-space(replace(.,',$',''))"/>
                        </xsl:for-each> 
                        
                    </persname>
            
                  </xsl:when>
                  
                  <xsl:when test="@tag='700'">
                      <persname source="lcnaf" encodinganalog="700">
                        <xsl:value-of select="replace(normalize-space(marc:subfield[@code='a']),'(\w{2})\.$','$1')"/>
                                                
                        <xsl:if test="marc:subfield[@code='b']">
                          <xsl:value-of select="normalize-space(marc:subfield[@code='b'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='q']">
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="normalize-space(marc:subfield[@code='q'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='c']">
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="normalize-space(marc:subfield[@code='c'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='d']">
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="normalize-space(replace(marc:subfield[@code='d'],'\.$',''))"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='e']">
                          <xsl:value-of select="normalize-space(marc:subfield[@code='e'])"/>
                        </xsl:if>
                        
                        <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                          <xsl:text> -- </xsl:text>
                          <xsl:value-of select="normalize-space(replace(.,',$',''))"/>
                        </xsl:for-each> 
                      </persname>
                  </xsl:when>
                </xsl:choose>
        
              </xsl:for-each>
            </xsl:if>
   
    
    
    
    <!-- MESH Personal Names - 600 only -->
      
    <xsl:if test="marc:datafield[@tag='600'][@ind1='1'][@ind2='2']">
      <xsl:for-each select="marc:datafield[@tag='600'][@ind1='1'][@ind2='2']">
                <xsl:sort select="marc:subfield[@code='a']"/>
                              
                      <persname source="mesh" encodinganalog="600">
                        
                        
                        <xsl:value-of select="replace(normalize-space(marc:subfield[@code='a']),'(\w{2})\.$','$1')"/>
                       
                        
                       
                        
                        <xsl:if test="marc:subfield[@code='q']">
                        <xsl:text> </xsl:text>
                          <xsl:value-of select="normalize-space(marc:subfield[@code='q'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='c']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(marc:subfield[@code='c'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='d']">
                        <xsl:text> </xsl:text>
                          <xsl:value-of select="normalize-space(replace(marc:subfield[@code='d'],'\.$',''))"/>
                        </xsl:if>
                        
                         
                        <xsl:if test="marc:subfield[@code='e']">
                        <xsl:value-of select="normalize-space(marc:subfield[@code='e'])"/>
                        </xsl:if>
                        
                        <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                          <xsl:text> -- </xsl:text>
                          <xsl:value-of select="normalize-space(replace(.,',$',''))"/>
                        </xsl:for-each>                      
                    </persname>
            
              </xsl:for-each>
            </xsl:if>
    
    
    
    
 
          <!--LCSH FAMILY NAMES -->
    <xsl:if test="marc:datafield[@tag='600'][@ind1='3'][@ind2='0'] | marc:datafield[@tag='600'][@ind1='3'][@ind2=' '] | marc:datafield[@tag='700'][@ind1='3']">
      <xsl:for-each select="marc:datafield[@tag='600'][@ind1='3'][@ind2='0'] | marc:datafield[@tag='600'][@ind1='3'][@ind2=' '] | marc:datafield[@tag='700'][@ind1='3']">
                <xsl:sort select="marc:subfield[@code='a']"/>
                <xsl:choose>
                  <xsl:when test="@tag='600'">
                    
                      <famname source="lcnaf" encodinganalog="600">
                        <xsl:value-of select="replace(normalize-space(marc:subfield[@code='a']),'\.$','')"/>
                        
                        <xsl:if test="marc:subfield[@code='q']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(marc:subfield[@code='q'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='d']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(replace(marc:subfield[@code='d'],'\.$',''))"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='e']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(marc:subfield[@code='e'])"/>
                        </xsl:if>
                        
                        <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                          <xsl:text> -- </xsl:text>
                          <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                      </famname>
                    
                  </xsl:when>
                  <xsl:otherwise>
                    
                      <famname source="lcnaf" encodinganalog="700">
                        <xsl:value-of select="replace(normalize-space(marc:subfield[@code='a']),'\.$','')"/>
                        
                        <xsl:if test="marc:subfield[@code='q']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(marc:subfield[@code='q'])"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='d']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(replace(marc:subfield[@code='d'],'\.$',''))"/>
                        </xsl:if>
                        
                        <xsl:if test="marc:subfield[@code='e']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(marc:subfield[@code='e'])"/>
                        </xsl:if>
                      </famname>
                    
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:if>
    
    
    <!--MESH FAMILY NAMES -->
    <xsl:if test="marc:datafield[@tag='600'][@ind1='3'][@ind2='2']">
      <xsl:for-each select="marc:datafield[@tag='600'][@ind1='3'][@ind2='2'] | marc:datafield[@tag='700'][@ind1='3']">
        <xsl:sort select="marc:subfield[@code='a']"/>
        
            <famname source="mesh" encodinganalog="600">
              <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="normalize-space(marc:subfield[@code='q'])"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="normalize-space(replace(marc:subfield[@code='d'],'\.$',''))"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="normalize-space(marc:subfield[@code='e'])"/>
              <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                <xsl:text> -- </xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </famname>
            
      </xsl:for-each>
    </xsl:if>
    
    
    
<!-- LC Corp Names (610 | 710) -->
    
           <xsl:if test="marc:datafield[@tag='610'][@ind2='0'] | marc:datafield[@tag='710']">
             <xsl:for-each select="marc:datafield[@tag='610'][@ind2='0'] | marc:datafield[@tag='710']">
                <xsl:sort select="marc:subfield[@code='a']"/>
                <xsl:choose>
                  
                  <!-- Keep periods if $b present -->
                  <xsl:when test="marc:subfield[@code='b'] and (marc:subfield[@code='x'] or marc:subfield[@code='v'] or marc:subfield[@code='y'] or marc:subfield[@code='z'])">
                    
                      <corpname source="lcnaf">
                        <xsl:attribute name="encodinganalog"><xsl:value-of select="./@tag"/></xsl:attribute>
                        <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
                        
                        <xsl:for-each select="marc:subfield[@code='b']">
                          <xsl:text> </xsl:text>
                           <xsl:value-of select="normalize-space(.)"/> 
                        </xsl:for-each>
                      
                        <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                          <xsl:text> -- </xsl:text>
                          <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
                        </xsl:for-each>
                      </corpname>
                  </xsl:when>
                  
                  <xsl:when test="marc:subfield[@code='b'] and not(marc:subfield[@code='x'] or marc:subfield[@code='v'] or marc:subfield[@code='y'] or marc:subfield[@code='z'])">
                    
                    <corpname source="lcnaf">
                      <xsl:attribute name="encodinganalog"><xsl:value-of select="./@tag"/></xsl:attribute>
                      <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
                      
                      <xsl:for-each select="marc:subfield[@code='b']">
                        <xsl:text> </xsl:text>
                        <xsl:choose>
                          <xsl:when test="position() = last()">
                            <!-- Keep trailing period if fewer than 5 characters in last word. For abbreviations - SUCH A HACK!! -->
                            <xsl:value-of select="normalize-space(replace(.,'(\w{5})\.$','$1'))"/>
                          </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)"/> 
                        </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>               
                    </corpname>
                  </xsl:when>

                  <xsl:when test="not(marc:subfield[@code='b'])">
                    
                    <corpname source="lcnaf">
                      <xsl:attribute name="encodinganalog"><xsl:value-of select="./@tag"/></xsl:attribute>
                      <xsl:value-of select="normalize-space(replace(marc:subfield[@code='a'],'\.$',''))"/>
                      
                      <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                        <xsl:text> -- </xsl:text>
                        <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
                      </xsl:for-each>
                    </corpname>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:if>
            
    <!-- MESH Corp Names -->
    
    <xsl:if test="marc:datafield[@tag='610'][@ind2='2']">
      <xsl:for-each select="marc:datafield[@tag='610'][@ind2='2'] | marc:datafield[@tag='710']">
        <xsl:sort select="marc:subfield[@code='a']"/>
                   
            <corpname source="mesh">
              <xsl:attribute name="encodinganalog"><xsl:value-of select="./@tag"/></xsl:attribute>
              <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
              <xsl:for-each select="marc:subfield[@code='b']">
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
              </xsl:for-each>
              <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                <xsl:text> -- </xsl:text>
                <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
              </xsl:for-each>
            </corpname>
            
      </xsl:for-each>
    </xsl:if>
    
    
 <!-- LCSH Geognames -->
    <xsl:if test="marc:datafield[@tag='651'][@ind2='0']">
      <xsl:for-each select="marc:datafield[@tag='651'][@ind2='0']">
                <xsl:sort select="marc:subfield[@code='a']"/>
                
                  <geogname source="lcsh" encodinganalog="651">
                    <xsl:value-of select="normalize-space(replace(marc:subfield[@code='a'],'\.$',''))"/>
                    <xsl:for-each select="marc:subfield[@code='b']">
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="normalize-space(.)"/>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
                      <xsl:text> -- </xsl:text>
                      <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
                    </xsl:for-each>
                  </geogname>
                
              </xsl:for-each>
            </xsl:if>
            
    <!-- MESH Geognames -->
    <xsl:if test="marc:datafield[@tag='651'][@ind2='2']">
      <xsl:for-each select="marc:datafield[@tag='651'][@ind2='2']">
        <xsl:sort select="marc:subfield[@code='a']"/>
        
        <geogname source="lcsh" encodinganalog="651">
          <xsl:value-of select="normalize-space(replace(marc:subfield[@code='a'],'\.$',''))"/>
          <xsl:for-each select="marc:subfield[@code='b']">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:for-each>
          <xsl:for-each select="marc:subfield[@code='x'] | marc:subfield[@code='v'] | marc:subfield[@code='y'] | marc:subfield[@code='z']">
            <xsl:text> -- </xsl:text>
            <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
          </xsl:for-each>
        </geogname>
        
      </xsl:for-each>
    </xsl:if>   
    
  <!-- AAT Genreform -->
    <!-- Don't get the FAST headings!! -->
    <xsl:if test="marc:datafield[@tag='655'][@ind2='7'] and not(marc:datafield[@tag='655'][@ind2='7']/marc:subfield[@code='2']='fast')">
              <xsl:for-each select="marc:datafield[@tag='655'][@ind2='7']/marc:subfield[@code='a']">
                <xsl:sort select="marc:subfield[@code='a']"/>
                
                  <genreform source="aat" encodinganalog="655">
                    <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
                  </genreform>
                
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:datafield[@tag='655'][@ind2='0']">
              <xsl:for-each select="marc:datafield[@tag='655'][@ind2='0']/marc:subfield[@code='a']">
                <xsl:sort select="marc:subfield[@code='a']"/>
               
                  <genreform source="lcsh" encodinganalog="655">
                    <xsl:value-of select="normalize-space(replace(.,'\.$',''))"/>
                  </genreform>
                
              </xsl:for-each>
            </xsl:if>
           
    <xsl:if test="marc:datafield[@tag='656']">
              <xsl:for-each select="marc:datafield[@tag='656']/marc:subfield[@code='a']">
                
                  <occupation encodinganalog="656">
                    <xsl:value-of select="normalize-space(.)"/>
                  </occupation>
                
              </xsl:for-each>
            </xsl:if>
            
    <xsl:if test="marc:datafield[@tag='657']">
              <xsl:for-each select="marc:datafield[@tag='657']/marc:subfield[@code='a']">
               
                  <function encodinganalog="657">
                    <xsl:value-of select="normalize-space(.)"/>
                  </function>
                
              </xsl:for-each>
            </xsl:if>
    
    <!-- Exclude uniform titles       
    <xsl:if test="marc:datafield[@tag='630']">
              <xsl:for-each select="marc:datafield[@tag='630']">
                
                  <title encodinganalog="630">
                    <xsl:value-of select="normalize-space(.)"/>
                  </title>
                
              </xsl:for-each>
            </xsl:if>
            -->
          
        </controlaccess>
  </xsl:if>
    
    
    <!-- RELATED MATERIAL -->
        
    <xsl:if test="marc:datafield[@tag='544']">
          <relatedmaterial encodinganalog="544">
            <head>Related Material</head>
            <xsl:for-each select="marc:datafield[@tag='544']">
            <p><xsl:value-of select="normalize-space(marc:subfield[@code='d'])"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="normalize-space(marc:subfield[@code='a'])"/>
            </p>
              </xsl:for-each>
          </relatedmaterial>
        </xsl:if>
     
  <!-- Create a single placeholder file level component, from which the digital item can be linked when it exists in the repository.
  Will need to use python script to find components based on refID, create and link digital objects to those components -->
  <dsc>
       <!-- Generate a UUID for the component. The UUID will serve as the ASpace component ref_ID, which can be carried over into the digitization guide -->
       <xsl:variable name="uuid" select="uuid:randomUUID()"/>
                     
       <c01>
         <xsl:attribute name="id">seca-<xsl:value-of select="$uuid"/></xsl:attribute>
         <xsl:attribute name="level">file</xsl:attribute>
         <did>
           <container type="folder">1</container>
           <unittitle>
             <!-- unittitle code reused from archdesc/unittitle code -->
             <xsl:value-of select="replace($CollectionTitle,',$','')"/>
             <!-- to account for 245$a that ends with : do not add comma -->
             <xsl:if test="marc:datafield[@tag='245']/marc:subfield [@code='b'] and not(ends-with($CollectionTitle, ':'))">
               <xsl:text>, </xsl:text>
               <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='245']/marc:subfield [@code='b'],'\.$',''))"/>
             </xsl:if>
             
             <xsl:if test="marc:datafield[@tag='245']/marc:subfield [@code='b'] and ends-with($CollectionTitle, ':')">
               <xsl:text> </xsl:text>
               <xsl:value-of select="normalize-space(replace(marc:datafield[@tag='245']/marc:subfield [@code='b'],'\.$',''))"/>
             </xsl:if>
           </unittitle>
           <unitdate><xsl:value-of select="$CollectionDate"/></unitdate>
         </did>
       </c01>
     </dsc>
    </archdesc>
    </ead>
</xsl:result-document>
  
<!-- Remove digguide creation script to separate XSLT that processes EADs.
Code below writes out some .txt files for each EADID showing RLID and some other metadata. 
TXT files are used purely as easy way to see next RLID in sequence -->

<xsl:result-document method="text" href="file:/C:/users/nh48/documents/github/sectionA_project/ead/{$box_number}/RL-{$RLID}.txt">
  <xsl:text>Collection_Num</xsl:text><xsl:value-of select="$tab"/>
  <xsl:text>Aleph_Num</xsl:text>
  <xsl:value-of select="$tab"/>
  <xsl:text>OCLC_Num</xsl:text>
  <xsl:value-of select="$tab"/>
  <xsl:text>EADID</xsl:text>
  <xsl:value-of select="$tab"/>
  <xsl:text>Collection_Title</xsl:text>
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="$newline"/>
  
  <xsl:text>RL.</xsl:text><xsl:value-of select="$RLID"/>
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="normalize-space(marc:controlfield[@tag='001'])"/>
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="normalize-space(marc:datafield[@tag='035'])"/>
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="normalize-space($EADID_unique)"/>
  <xsl:value-of select="$tab"/>
  <xsl:value-of select="$CollectionTitle"/><xsl:text> </xsl:text><xsl:value-of select="$CollectionDate"/>
  <xsl:value-of select="$tab"/>
  
</xsl:result-document>

  
 
</xsl:template>
</xsl:stylesheet>