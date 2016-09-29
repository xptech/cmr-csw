# CMR Catalogue Service for the Web #
This file contains notes that can be useful with coming up to speed with 
development of the CMR CSW application.

This file uses the GitHub markdown language. [Learn Markdown here.](https://bitbucket.org/tutorials/markdowndemo)

### Application Profiling using the [ruby-prof gem](https://github.com/ruby-prof/ruby-prof) ###
 The application is set up for performance profiling.
 It uses the ruby-prof profiling gem (only works for MRI ruby) and the _:profile_ group in the Gemfile:
~~~~    
    group :profile do
      gem 'ruby-prof'
    end
~~~~
 In order to profile the application it has to run in the 'profile' environment via the command:
~~~~
    rails server -e profile
~~~~
 It produces memory profiling statistics and stores them under the:

    `log/rubyprof` directory

 The following ruby-prof formats are created:
 
* `csw-collections-csw-flat.txt`: text file showing the amount of time spent in each function, with the funnctions at the top being the slowest.
Format examples and detailed explanations are [here](https://github.com/ruby-prof/ruby-prof/blob/master/examples/flat.txt).
* `csw-collections-csw-graph.txt`: text file with function callers and calees to be used in conjunction with the flat file showing the amount of time.
Format examples and detailed explanations are [here](https://github.com/ruby-prof/ruby-prof/blob/master/examples/graph.txt).
* `csw-collections-csw-graph.html`: HTML version of the call graph showing, more intuitive than the text version.
Detailed explanations for each column are identical to the [plain text graph report](https://github.com/ruby-prof/ruby-prof/blob/master/examples/graph.txt).
* `csw-collections-csw-call-stack.html`:  HTML version of the call stack, easier to understand
* `csw-collections-csw-call-grind.out.app`: callgrind format used by the Valgrind C/C++ profiler.  Visualization works well with [qcachegrind](http://brewformulas.org/Qcachegrind).
Install the qcachegrind visualization package via homebrew (macports is also an option):
~~~~    
    brew install qcachegrind --with-graphviz
    sudo brew linkapps qcachegrind
~~~~
 
 The metrics captured in the above reports are: 
 
* `%self`: percentage of time spent only in the function
* `total`: total time spent in this function, including the execution of functions that it calls
* `self`: the total time spent only in this function, excluding the execution of functions that it calls 
* `wait`: time spent waiting for other threads.  This columnn can be ignored due to the MRI Global Interpreter Lock (GIL).
* `child`: time spent in functions that are called from this function
* `calls`: the number of times the fuction was called

### Issues ###
#### Who do I talk to? ####

_Calin Duma_ or _Doug Newman_

### External references ####

* [All the CSW Specifications](http://www.opengeospatial.org/standards/cat#downloads)
* [CSW 2.0.2 Specification being used by CMR CSW ](http://portal.opengeospatial.org/files/?artifact_id=20555)
* [CSW 2.0.2 ISO Metadata Application Profile being used by CMR CSW](http://portal.opengeospatial.org/files/?artifact_id=21460)
* [OWS Schemas (used by CSW schemas)](http://schemas.opengis.net/ows/)
* [OGC Filter constraint language schemas](http://schemas.opengis.net/filter/)
* [Good high level CSW explanation and examples](http://wiki.osgeo.org/wiki/CSW)
* [A Common (aka Contextual) Query Language (CQL) introduction](http://zing.z3950.org/cql/intro.html)
* [The Contextual (aka Common) Query Language specification](http://docs.oasis-open.org/search-ws/searchRetrieve/v1.0/os/part5-cql/searchRetrieve-v1.0-os-part5-cql.html)