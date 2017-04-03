# sectionA_project
Various files (MARC, EAD) and helper scripts (XSLT) related to the Rubenstein Library's project to digitize roughly 3,000 small, mostly single-folder, manuscript collections that are housed in "Section A."

Metadata crosswalk documentation: https://docs.google.com/document/d/1h-CaFHsyN3rciROCE5WiADGm8f9ZP6dwnsuKsauBL0U/edit

## What's in here?

### Subfolders:

* **/marc** - contains raw MARC21 files exported from Aleph. Search Aleph for call number for box ("Sec A Box 1") and export records as batch file

* **/marcxml** - contains marcxml files converted from raw marc in /marc using MARCEdit's built-in MARC21toMARCXML crosswalk

* **/ead** - contains EAD files converted from marcxml using marc2ead_sectionA.xsl. These EAD files can be imported into ArchivesSpace.

* **/digguides** - contains TSV files created by processing all XML files within a subfolder of /EAD (ead/secA_001) using ead2digguides.xsl

### Scripts and such
* **marc2ead_sectionA.xsl** - converts a batch MARCXML file into individual EAD files suitable for importing into ArchivesSpace

* **ead2digguide.xsl** - processes all EAD files within a subfolder (e.g. ead/secA_001) to create a single digitization guide (TSV). The digitization guide can be used to facilitate digitization, repository ingest, and as the basis for repository metadata.

* **MARC21slimUtils.xsl** - a utility XSLT script packaged with MARCEdit. marc2ead_sectionA.xsl references this script.

* **sectionA_oxygen_project.xpr** - an Oxygen XML editor project file that contains Oxygen settings for various views, translation scenarios, and validation scenarios.

* **as_seca_publish_update_eads.py** - A Python script that reads a TSV file in /digguides and uses the value of the EADID column to batch lookup resource records in ArchivesSpace using the ArchivesSpace API and then export them as EAD. The script also correctly parses the resource record identifier into two fields in ASpace (id_0 and id_1) and posts it back with the finding_aid_status value of "published".
