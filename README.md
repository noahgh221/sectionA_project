# sectionA_project
Various files (MARC, EAD) and helper scripts (XSLT) related to the Rubenstein Library's Section A digitization project.

## What's in here?

### Subfolders:

* **/marc** - contains raw MARC21 files exported from Aleph. Search Aleph for call number for box ("Sec A Box 1") and export records as batch file

* **/marcxml** - contains marcxml files converted from raw marc in /marc using MARCEdit's built-in MARC21toMARCXML crosswalk

* **/ead** - contains EAD files converted from marcxml using marc2ead_sectionA.xsl

* **/digguides** - contains TSV files created by processing all XML files within a subfolder of EAD (ead/secA_001) using ead2digguides.xsl

### XSLT and other files
* **marc2ead_sectionA.xsl** - converts a batch MARCXML file into individual EAD files suitable for importing in ArchivesSpace

* **ead2digguide.xsl** - processes all EAD files within a subfolder (e.g. ead/secA_001) to create a single digitization guide (TSV). The digitization guide can be used to facilitate digitization, repository ingest, and as the basis for repository metadata.

* **MARC21slimUtils.xsl** - a utility XSLT script packaged with MARCEdit. marc2ead_sectionA.xsl references this script.

* **sectionA_oxygen_project.xpr** - an Oxygen XML editor project file. Contains Oxygen settings for various views, translation and validation scenarios.
