# sectionA_project
Various files (MARC, EAD) and helper scripts (XSLT) related to the Rubenstein Library's project to digitize roughly 3,000 small, mostly single-folder, manuscript collections that are housed in "Section A."

Metadata crosswalk documentation: https://docs.google.com/document/d/1h-CaFHsyN3rciROCE5WiADGm8f9ZP6dwnsuKsauBL0U/edit

MARC Remediation documentation: https://docs.google.com/document/d/1HkPQVHVkSo1Fq1k7zmu9xyrS2Ic7smPt3FYEKBI_5-E/edit?usp=sharing

## What's in here?

### Subfolders:

* **/marc** - contains raw MARC21 files exported from Aleph. Search Aleph for call number for box ("Sec A Box 1") and export records as batch file

* **/marcxml** - contains marcxml files converted from raw marc in /marc using MARCEdit's built-in MARC21toMARCXML crosswalk

* **/ead** - contains EAD files converted from marcxml using marc2ead_sectionA.xsl. These EAD files can be imported into ArchivesSpace. EAD FILES ARE NO LONGER BEING IMPORTED INTO ASPACE AS OF 2019, BUT STILL GENERATED TO FACILITATE CROSSWALKING PROCESS.

* **/digguides** - contains TSV files created by processing all XML files within a subfolder of /EAD (ead/secA_001) using ead2digguides.xsl

* **/completed_digguides** - contains TSV files with descriptive metadata about each collection (same as above) in addition to technical and administrative metadata produced during scanning

### Scripts and such
* **marc2ead_sectionA.xsl** - An old, repurposed, and convoluted XSLT that converts a batch MARCXML file into individual EAD files suitable for importing into ArchivesSpace.

* **ead2digguide.xsl** - processes all EAD files within a subfolder (e.g. ead/secA_001) to create a single digitization guide (TSV). The digitization guide can be used to facilitate digitization, repository ingest, and as the basis for repository metadata. Modify this script if new seca-from-googlesheet.xml file is generated to account for new rights statement URIs added since the last run.

* **MARC21slimUtils.xsl** - a utility XSLT script packaged with MARCEdit. marc2ead_sectionA.xsl references this script.

* **sectionA_oxygen_project.xpr** - an Oxygen XML editor project file that contains Oxygen settings for various views, translation scenarios, and validation scenarios.

* **as_seca_publish_update_eads.py** - A Python script that reads a TSV file in /digguides and uses the value of the EADID column to batch lookup resource records in ArchivesSpace using the ArchivesSpace API and then export them as EAD. The script also correctly parses the resource record identifier into two fields in ASpace (id_0 and id_1) and posts it back with the finding_aid_status value of "published". THIS SCRIPT IS NO LONGER IN USE.

* **seca-from-googlesheet.xml** - XML file exported from Google Sheets using a Google Sheet add-on. Allows ead2digguide.xsl to grab Rights Statement URI values stored in the Google Sheet and insert them in the digguides. This file should be regenerated each if more rights statements are added to the Google Sheet. The ead2digguide.xsl should also be modified to access any new exports. See comments in that script
