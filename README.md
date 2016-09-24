# README #
This file contains the issues identified during the development of CMR CSW.  It
is focused on differences between the IDN/GCMD CSW and CMR CSW mainly due to
the initial CMR Search capabilities, which contains functionality which is
exposed via a CSW standard.
It also contains notes that can be useful with coming up to speed with 
development of the CMR CSW application.

This file uses the GitHub markdown language. [Learn Markdown here.](https://bitbucket.org/tutorials/markdowndemo)

### Application Profiling using RubyProd and qcachegrind ###
 Use the ruby-prof profiling gem (for MRI ruby) and the :profile group:
~~~~    
    group :profile do
      gem 'ruby-prof'
    end
~~~~
 
 Install the qcachegrind visualization package:
~~~~    
    brew install qcachegrind --with-graphviz
    sudo brew linkapps qcachegrind
~~~~

 Configure the ruby-prof gem to generate qcachegrind output:
   See the [Profiling Rails Section of the ruby-prof gem documentation.](https://github.com/ruby-prof/ruby-prof)   

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

    The GCMD queryables that CMR CSW will **not support**  in the initial 
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

* Query Language 
    The two flavors of query language are:
    * the OGC filter
    * the Common Query language
    We'll have to write translators from the supported flavors to the CMR
    search query language.
    
    The initial CMR CSW specification will support FILTER as the initial constraint
laguage. Learn about the [OGC Filter constraint language] (http://schemas.opengis.net/filter/).  
The Common Query Language (CQL) will only be supported if needed.  Learn about CQL [here] (http://zing.z3950.org/cql/intro.html).

* Spatial capabilities
    The spatial capabilities comprise of Spatial Operators and Geometry Operands.  They are
a bit randomly qualified in the GCMD GetCapabilities.
    * Spatial Operators
        The spatial operators supported by CMR CSW are:
        "Intersects"
        "BBOX" - for some reason, OpenGis classifies BBOX as a spatial operator instead
        of a geometry operand, together with Point, Line, Polygon
        
        The spatial operators **not supported** by the CMR CSW initial implementation are:
        "Equals"
        "Overlaps" (we will map this to "Intersects")
        "Disjoint" 
        "Touches" (we will map this to "Intersects")
        "Crosses" (we will can map this to "Intersects")
        "Within"
        "Contains"
    * Geometry Operands
        The geometry operands supported by CMR CSW are:
        "Point"
        "Line"
        "Polygon"

        The geometry operands **not supported** by the CMR CSW initial implementation:
        "Envelope"
        
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

### GetRecords ###
##### Quick summary #####
* The CMR CSW GetRecords request is only supported via POST.  GCMD does not support 
GetRecords GET even though it is in the GetCapabilities.  Neither does CWIC but CWIC
returns a meaningful error message (REQUEST_EXCEPTION: UNRECOGNIZED_REQUEST - Only Getcapabilities, 
DescribeRecord and GetRecordById supported for HTTP GET method).  Probably the reason is that one can't 
express meaningful queries via the query parameters unless one supports some basic CQL.  The only way CWIC
and GCMD CSW support GetRecords is via POST and request payloads that contain the query / filter.  For now 
the CMR CSW GetRecords GET always returns an exception stating that only POST is supported.  
That is also reflected in the CMR CSW GetCapabilities response.
 
##### Issues #####

### Who do I talk to? ###

_Doug Newman_
_Calin Duma_

### External references ####

* [All the CSW Specifications](http://www.opengeospatial.org/standards/cat#downloads)
* [CSW 2.0.2 Specification being used by CMR CSW ](http://portal.opengeospatial.org/files/?artifact_id=20555)
* [CSW 2.0.2 ISO Metadata Application Profile being used by CMR CSW](http://portal.opengeospatial.org/files/?artifact_id=21460)
* [OWS Schemas (used by CSW schemas)](http://schemas.opengis.net/ows/)
* [OGC Filter constraint language schemas] (http://schemas.opengis.net/filter/)
* [Good high level CSW explanation and examples] (http://wiki.osgeo.org/wiki/CSW)
* [A Common (aka Contextual) Query Language (CQL) introduction] (http://zing.z3950.org/cql/intro.html)
* [The Contextual (aka Common) Query Language specification] (http://docs.oasis-open.org/search-ws/searchRetrieve/v1.0/os/part5-cql/searchRetrieve-v1.0-os-part5-cql.html)

