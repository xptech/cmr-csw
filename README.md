# README #
This file contains the issues identified during the development of CMR CSW.  It
is focused on differences between the IDN/GCMD CSW and CMR CSW mainly due to
the initial CMR Search capabilities, which contains functionality which is
exposed via a CSW standard.

This file uses the GitHub markdown language. [Learn Markdown here.](https://bitbucket.org/tutorials/markdowndemo)

### GetCapabilities findings ### 
##### Quick summary #####
The initial CMR CSW implementation will focus on using existing CMR search
functionality.  Once the need for additional supports exists, we might 
consider expanding CMR search and subsequently CMR CSW based on new CMR
search functionality.
##### Issues #####
* Queryables (filtering properties)

The initial CMR queryable properties will be a subset of the GCMD CSW
queryable properties.  The GCMD supported queryables supported by CMR CSW
are:
"Title"
"Anytext"
"Identifier"
"Modified"
"RevisionDate"
"OrganisationName"
"ResourceIdentifier"
"TempExtent_begin"
"TempExtent_end"
"Project"
"Platform"
"Location"
"ScienceKeywords"
"Instrument"

The GCMD queryables that CMR CSW will **not** support in the initial 
implementation:
"Subject"
"Abstract"
"Format"
"Type"
"AlternateTitle"
"CreationDate"
"PublicationDate"
"HasSecurityConstraints"
"Language"
"ParentIdentifier"
"KeywordType"
"TopicCategory"
"ResourceLanguage"
"ServiceType"
"ServiceTypeVersion"
"Operation"
"Denominator"
"DistanceValue"
"DistanceUOM"
"GeographicDescription Code"
"CouplingType"
"OperatesOn"
"OperatesOnIdentifier"
"OperatesOnName"
"Lineage"
"ConditionApplyingToAccessAndUse"
"AccessConstraints"
"OnlineResourceMimeType"
"ResponsiblePartyRole"
"OnlineResourceType"
"SpecificationDate"
"MetadataPointOfContact"
"Classification"
"OtherConstraints"
"Degree"
"SpecificationTitle"

### GetDomain findings ### 
##### Quick summary #####
* The GetDomain request 

##### Issues #####


### DescribeRecord findings ### 
##### Quick summary #####
* The DescribeRecord request 

##### Issues #####

### GetRecordById ###
##### Quick summary #####
* The GetRecordById request
 
##### Issues #####


### Who do I talk to? ###

_Doug Newman_
_Calin Duma_

### External schema references ####

* [All the CSW Specifications](http://www.opengeospatial.org/standards/cat#downloads)
* [CSW 2.0.2 Specification being used by CMR CSW ](http://portal.opengeospatial.org/files/?artifact_id=20555)
* [CSW 2.0.2 ISO Metadata Application Profile being used by CMR CSW](http://portal.opengeospatial.org/files/?artifact_id=21460)
* [OWS Schemas (used by CSW schemas)](http://schemas.opengis.net/ows/)