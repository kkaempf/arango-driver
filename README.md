<h1 align="center">
  arangodb-driver
  <br/>
  <br/>
  <img src="https://raw.githubusercontent.com/kkaempf/arangodb-driver/master/docs/arangodb-driver.png" align="center"/>
</h1>

[![Gem Version](https://badge.fury.io/rb/arangodb-driver.svg)](https://badge.fury.io/rb/arangodb-driver)

# About arangodb-driver

arangodb-driver is a drop-in replacement for the (archived) [arango-driver](https://github.com/janbiedermann/arango-driver).


The [Arango database](https://www.arangodb.com/) is a native multi-model database with flexible data models for document, graphs, and key-values.

arangodb-driver is a Gem to use ArangoDB with Ruby.

arangodb-driver is based on the [HTTP API of ArangoDB](https://docs.arangodb.com/3.8/HTTP/index.html) and its [Error Codes](https://www.arangodb.com/docs/3.8/appendix-error-codes.html).

The version of arangodb-driver follows the ArangoDB version, version 3.10.x of the driver is meant to be used with ArangoDB 3.10.y, where x and y may differ. 

### History

The history of arangodb-driver is long and twisted.

It started with [ArangoRB](https://github.com/StefanoMartin/ArangoRB), converted to [arango-driver](https://github.com/janbiedermann/arango-driver)
and converted again to [arangodb-driver](https://github.com/kkaempf/arangodb-driver).

The main purpose of the last rename was to get it published at [rubygems.org](https://rubygems.org/gems/arangodb-driver)

## Installation

To install arangodb-driver: `gem install arangodb-driver` 
To use it in your application: `require "arangodb-driver"`

## Community and Support

Please open issues at the arangodb-driver [github project](https://github.com/kkaempf/arangodb-driver/issues)

# This is currently WIP, the information below is mostly obsolete. See spec/*_spec.rb files for currently supported things and usage.

## Classes used

arangodb-driver has the two type of classes.

Classes relative to ArangoDB elements:

* [Arango::Server](#ArangoServer): to manage a Server
* [Arango::Database](#ArangoDatabase): to manage a Database
* [Arango::Collection](#ArangoCollection): to manage a Collection
* [Arango::Document](#ArangoDocument): to manage a Document
* [Arango::Vertex](#ArangoVertex): to manage a Vertex
* [Arango::Edge](#ArangoEdge): to manage an Edge
* [Arango::Graph](#ArangoGraph): to manage a Graph
* [Arango::Traversal](#ArangoTraversal): to manage a Traversal operation
* [Arango::AQL](#arangoaql): to manage an AQL instances
* [Arango::User](#ArangoUser): to manage an User
* [Arango::Index](#ArangoIndex): to manage an Index
* [Arango::Task](#ArangoTask): to manage a Task
* [Arango::Transaction](#ArangoTransaction): to manage a Transaction
* [Arango::Replication](#ArangoReplication): to manage a Replication
* [Arango::Foxx](#ArangoFoxx): to manage a Foxx instance
* [Arango::View](#ArangoView): to manage a View instance

Classes relative to the Gem arangodb-driver
* [Arango::Cache](#ArangoCache): to manage internal Cache
* [Arango::Error](#ArangoError): to handle arangodb-driver errors

All the instances of these classes can be transformed in Hash with the method to_h.

Many methods can have multiple attributes not mentioned in this documentation. Keep in mind that if an attribute is defined in the ArangoDB documentation, then it is easy that it is an attribute for the relative method too.
Please refer to the ArangoDB documentation, the rubydoc documentation or open an issue for this missing attributes.

<a name="ArangoServer"></a>
## Arango::Server

Arango::Server is used to manage a single server by managing the connection with ArangoDB.
You can provide your login credentials and it is a mandatory step to start your database.

To setup a server use the following way:

``` ruby
server = Arango::Server.new username: "MyUsername", password: "MyPassword",
  server: "localhost", port: "8529", tls: false
server.username = "MyOtherUsername" # Default "root"
server.password = "other_password"  
server.server   = "127.0.0.1"       # Default "localhost"
server.port     = "8765"            # Default "8529"
server.tls      = true   # Default false, to do https requests instead of http
```

Password is a mandatory field.

### Returning results

arangodb-driver tries always to store the information obtained from ArangoDB in an instance.
If you need to receive the output, you can return it with:

``` ruby
server.return_output = true # Default false
```

### Verbose and warnings

For Debugging reasons the user can print out the request and response to ArangoDB by setting verbose to true.

``` ruby
server.verbose = true # Default false
```

Remember that verbose is only for testing reason: to work efficiently verbose should be false.

Some deprecated methods will return a warning. To silence these warnings use:

``` ruby
server.warning = false # Default true
```

### Connection Pool

arangodb-driver supports connection pool, to activate it you can setup pool to true during the initialization or the proceedings. To do so use:

``` ruby
server = Arango::Server.new username: "MyUsername", password: "MyPassword",
  server: "localhost", port: "8529", pool: true, size: 5, timeout: 5, tls: false
server.pool = true  # Defult false
server.size = 7     # Default 5
server.timeout = 10 # Default 5
server.restartPool  # Restart pool with new size and timeout
```

NB: ConnectionPool is not heavily tested.

### Cache

Often arangodb-driver returns multiple time the same object (for example for lists or for retrieving). It can happens thus that a document instance updated somewhere in your code, it is not update somewhere even if you are refering the same ArangoDB document.
To avoid this, arangodb-driver provides its own cache.

You can activate the arangodb-driver cache by using:

``` ruby
server.active_cache = true # Default false
```

If active_cache is true, then a previous document or collection instance will be stored in the arangodb-driver cache. In case a new instance of the same document is created, then a new instance will NOT be created but, instead, the old one will be returned.

With an example:

``` ruby
server.active_cache = false
a = Arango::Document.new name: "test", collection: my_collection
b = Arango::Document.new name: "test", collection: my_collection
# In this case a and b are two different instances
```

``` ruby
server.active_cache = true
a = Arango::Document.new name: "test", collection: my_collection
b = Arango::Document.new name: "test", collection: my_collection
# In this case a and b are the same instance
```

Note that if you set server.active_cache to false, then the stored Cache will be emptied.
For more information about the cache, look at the section about [Arango::Cache](#ArangoCache).

### Information

Basic information can be retrieved with these command.

``` ruby
server.to_h      # Return an hash of the instances
server.endpoint  # Check address used to connect with the server
server.username  # Check name used to connect with the server
server.verbose   # Check if verbose is true or false
server.async     # Check the status of async
```

To retrieve lists

``` ruby
server.databases # Lists of available databases
server.endpoints # Lists of endpoints used
server.users     # Lists of available users
server.tasks     # Lists of available tasks
```

To monitoring the server you can use the following commands

``` ruby
server.log # Return log files
server.loglevel
server.updateLoglevel body: body
server.available?    # Reloads the routing information from the collection routing.
server.reload        # Reloads the routing information from the collection routing.
server.statistics    # Returns the statistics information
server.statisticsDescription # Fetch descriptive info of statistics
server.status     # Status of the server
server.role       # Get to know whether this server is a Coordinator or DB-Server
server.serverData # Get server data
server.mode       # Get server mode
server.updateMode(mode: "default") # Change mode of the server
```

### Manage Async

With Arango::Server you can manage Async results. It can be useful to use async for heavy requests (like the one in example/year.rb).

``` ruby
server.async = false  # default
server.async = true   # fire and forget
server.async = :store # fire and store
```

If Async is "store", then the commands of arangodb-driver will return the id of the Async requests.
Arango::Server provides different methods to manage these Async requests.

``` ruby
server.fetchAsync    id: id # Fetches a job result and removes it from the queue
server.cancelAsync   id: id # Cancels an async job
server.destroyAsync  id: id # Deletes an async job result
server.retrieveAsync id: id # Returns the status of a specific job
server.retrieveAsyncByType type: type # Returns the ids of job results with a specific
# status. Type can be "done" or "pending"
server.retrieveDoneAsync       # Equivalent to server.retrieveAsync type: "done"
server.retrievePendingAsync    # Equivalent to server.retrieveAsync type: "pending"
server.destroyAsync type: type # Deletes async jobs with a specific status
                               # Type can be "all" or "expired"
server.destroyAllAsync         # Equivalent to server.destroyAsync type: "all"
server.destroyExpiredAsync     # Equivalent to server.destroyAsync type: "expired"
```

### Miscellaneous

``` ruby
server.version           # Returns the server version number
server.engine            # Returns the server engine
server.flushWAL          # Flushes the write-ahead log
server.propertyWAL       # Retrieves the configuration of the write-ahead log
server.changePropertyWAL # Configures the write-ahead log
server.transactions      # Returns information about the currently running transactions
server.time              # Get the current time of the system
server.echo              # Return current request
server.databaseVersion   # Return the required version of the database
server.shutdown          # Initiate shutdown sequence
```

UNTESTED

``` ruby
server.test body: body    # Runs tests on server
server.execute body: body # Execute a script on the server.
```

### Cluster (UNTESTED)

ArangoDB permits the sharding of the database. Although these methods has not been tested with arangodb-driver.

``` ruby
server.clusterHealth port: port # Allows to check whether a given port is usable
server.serverId                 # Returns the id of a server in a cluster.
server.clusterStatistics dbserver: dbserver # Allows to query the statistics of a
                                            # DBserver in the cluster
```

<a name="ArangoDatabase"></a>
## Arango::Database

Arango::Database is used to manage a Database. You can create an instance in one of the following ways:

``` ruby
myDatabase = server.database name: "MyDatabase"
myDatabase = server["MyDatabase"]
myDatabase = Arango::Database.new database: "MyDatabase", server: server
```

### Main methods

``` ruby
myDatabase.create   # Create a new Database
myDatabase.retrieve # Retrieve database
myDatabase.destroy   # Delete the selected Database
```

### Retrieve information

``` ruby
server.databases       # Obtain an Array with the available databases in the server
myDatabase.to_h        # Hash of the instance
myDatabase.info        # Obtain general info about the databases
myDatabase.sever       # Return the server connected with the database
myDatabase.collections # Obtain an Array with the available collections in the selected Database
myDatabase.graphs       #  Obtain an Array with the available graphs in the selected Database
myDatabase.aqlFunctions #  Obtain an Array with the available functions in the selected Database
myDatabase.foxxes # Return all the foxx available in the database
myDatabase.views  # Return all the views available in the database
myDatabase.tasks  # Return all the tasks available in the database
```

<a name="arangoaql"></a>
## Arango::AQL

An AQL instance can be created by using one of the following way:

``` ruby
query = "FOR v,e,p IN 1..6 ANY 'Year/2016' GRAPH 'MyGraph' FILTER p.vertices[1].num == 6 && p.vertices[2].num == 22 && p.vertices[6]._key == '424028e5-e429-4885-b50b-007867208c71' RETURN [p.vertices[4].value, p.vertices[5].data]"
myQuery = myDatabase.aql query: query
myQuery = ArangoAQL.new database: myDatabase, query: query
```

To execute it use:

``` ruby
myQuery.execute
```

If the query is too big, you can divide the fetching in pieces, for example:

``` ruby
myQuery.size = 10
myQuery.execute # First 10 documents
myQuery.next    # Next 10 documents
myQuery.next    # Next 10 documents
```

Other useful methods are the following

``` ruby
myQuery.destroy # Destroy cursor to retrieve documents
myQuery.kill    # Kill query request (if requires too much time)
myQuery.explain # Show data query
myQuery.parse   # Parse query
```

### Query Properties

It is possible to handle generic properties of query by Arango::Database.

``` ruby
myQuery.to_h                                # Return an hash version of the instance
myQuery.properties                          # Check Query properties
myQuery.current                             # Retrieve current running Query
myQuery.changeProperties maxSlowQueries: 65 # Change Properties
myQuery.slow                                # Retrieve slow Queries
myQuery.stopSlowQueries                     # Stop slow Queries
```

The cache of the query can handle in the following way:

``` ruby
myDatabase.retrieveQueryCache                      # Retrieve Query Cache
myDatabase.clearQueryCache                         # Clear Query Cache
myDatabase.propertyQueryCache                      # Check properties Cache
myDatabase.changePropertyQueryCache maxResults: 30 # Change properties Cache
```

### AQL Functions

AQL queries can be potentiate by providing javascript function as supports.

``` ruby
myDatabase.createAqlFunction code: "function(){return 1+1;}", name: "myFunction" # Create a new AQL Function
myDatabase.deleteFunction name: "myFunction" # Delete an AQL function
myDatabase.aqlFunctions # Retrieve a list of the available aql functions
```

<a name="ArangoCollection"></a>
## Arango::Collection

Arango::Collection is used to manage your Collections. You can create an Arango::Collection instance in one of the following way:

``` ruby
myCollection = myDatabase.collection name: "MyCollection"
myCollection = myDatabase["MyCollection"]
myCollection = Arango::Collection.new database: myDatabase, collection: "MyCollection"
```

A Collection can be of two types: "Document" and "Edge". If you want to specify it, uses:

``` ruby
myCollectionA = ArangoCollection.new collection: "MyCollectionA", type: :document # Default
myEdgeCollection = ArangoCollection.new collection: "MyCollectionB", type: :edge
```

### Main methods

``` ruby
myCollection.create   # Create collection
myCollection.destroy  # Delete collection from database
myCollection.truncate # Delete all the Documents inside the selected Collection
myCollection.retrieve # Retrieve the selected Collection
```

### Info methods

``` ruby
myCollection.database   # Return database of the collection
myCollection.server     # Returm server of the collection
myCollection.indexes    # Return a list of all used Indexes in the Collection
myCollection.rotate     # Rotate the collection
myCollection.data       # Returns the whole content of one collection
myCollection.properties # Properties of the Collection
myCollection.count      # Number of Documents in the Collection
myCollection.stats      # Statistics of the Collection
myCollection.revision   # Return collection revision id
myCollection.checksum   # Return checksum for the Collection
```

### Modify the Collection

``` ruby
myCollection.load   # Load the collection (preparing for retrieving documents)
myCollection.unload # Unload the collection (if you stop to work with it)
myCollection.loadIndexesIntoMemory            # Load indexes in memory
myCollection.change(waitForSync: true)        # Change some properties
myCollection.rename(newName: "myCollection2") # Change name (NB: This is not Arango::Cache compatible)
myCollection.rotate # Rotate journal of a collection
```

### Handle documents

To retrieve all the documents of a Collection you can use:

``` ruby
myCollection.documents
myCollection.allDocuments
```

These two functions are similar except for the fact that you can assign different variables.

``` ruby
myCollection.documents type: "path"
myCollection.next # Retrieve other documents if the first request is not finished
```

Type can be "path", "id" or "key" in relation what we wish to have. If not specified arangodb-driver will return an array of Arango::Document instances.

``` ruby
myCollection.allDocuments skip: 3, limit: 100, batchSize: 10
```

It means that we skip the first three Documents, we can retrieve the next 100 Documents but we return only the first ten.

To retrieve specific Document you can use:

``` ruby
myCollection.documentsMatch match: {value: 4}       # All Documents of the Collection with value equal to 4
myCollection.documentMatch match: {value: 4}        # The first Document of the Collection with value equal to 4
myCollection.documentByKeys keys: ["4546", "4646"]  # Documents of the Collection with the keys in the Array
myCollection.documentByName names: ["4546", "4646"] # Documents of the Collection with the name in the Array
myCollection.random                                 # A random Document of the Collection
```

#### Modifying multiple documents

From a collection is it possible to create, remove and modify multiple documents.

``` ruby
myCollection.createDocuments document: [myDocumentA, myDocumentB, {value:  17}] # Array of Arango::Document instances and Hashes
myCollection.removeByKeys keys: ["4546", "4646"] # Documents of the Collection with the keys in the Array will be removed
myCollection.removeMatch match: {value:  4} # All Documents of the Collection with value equal to 4 will be removed
myCollection.replaceMatch match: {value:  4}, newValue: {value:  6} # All Documents of the Collection with value equal to 4 will be replaced with the new Value
myCollection.updateMatch match: {value:  4}, newValue: {value:  6} # All Documents of the Collection with value equal to 4 will be updated with the new Value
```

#### Create multiple Edges at once

We have the possibility to create different combination of Edges in only one line of code.

One-to-one with one Edge class

 * [myDocA] --(myEdge)--> [myDocB]

``` ruby
myEdgeCollection.createEdges document: myEdge, from: myDocA, to: myDocB
```

One-to-more with one Edge class (and More-to-one with one Edge class)

 * [myDocA] --(myEdge)--> [myDocB]
 * [myDocA] --(myEdge)--> [myDocC]

``` ruby
myEdgeCollection.createEdges document: myEdge, from: myDocA, to: [myDocB, myDocC]
```

More-to-More with one Edge class

 * [myDocA] --(myEdge)--> [myDocC]
 * [myDocB] --(myEdge)--> [myDocC]
 * [myDocA] --(myEdge)--> [myDocD]
 * [myDocB] --(myEdge)--> [myDocD]

``` ruby
myEdgeCollection.createEdges document: myEdge, from: [myDocA, myDocB], to: [myDocC, myDocD]
```

More-to-More with more Edge classes

 * [myDocA] --(myEdge)--> [myDocC]
 * [myDocB] --(myEdge)--> [myDocC]
 * [myDocA] --(myEdge)--> [myDocD]
 * [myDocB] --(myEdge)--> [myDocD]
 * [myDocA] --(myEdge2)--> [myDocC]
 * [myDocB] --(myEdge2)--> [myDocC]
 * [myDocA] --(myEdge2)--> [myDocD]
 * [myDocB] --(myEdge2)--> [myDocD]

``` ruby
myEdgeCollection.createEdges document: [myEdge, myEdge2], from: [myDocA, myDocB], to: [myDocC, myDocD]
```


### Import and Export Documents

Another way to create multiple documents in a Collection with only one request is by using the method import.

#### Import one Document with Array

We can import one document with the following structure {value: "uno", num: 1, name: "ONE"}.

``` ruby
attributes = ["value", "num", "name"]
values     = ["uno",1,"ONE"]
myCollection.import attributes: attributes, values: values
```

#### Import more Documents with Array

We can import three Documents with the following structure {value: "uno", num: 1, name: "ONE"}, {value: "due", num: 2, name: "TWO"}, {value: "tre", num: 3, name: "THREE"}.

``` ruby
attributes = ["value", "num", "name"]
values     = [["uno",1,"ONE"],["due",2,"TWO"],["tre",3,"THREE"]]
myCollection.import attributes: attributes, values: values
```

#### Import more Documents with JSON

I import two Documents with the following structure {value: "uno", num: 1, name: "ONE"}, {value: "due", num: 2, name: "TWO"}.

``` ruby
body = [{value: "uno", num: 1, name: "ONE"}, {value: "due", num: 2, name: "DUE"}]
myCollection.importJSON body: body
```

#### Export files

As it is possible to import files, it is possible to export all the Document of a Collection with the following command.

``` ruby
myCollection.export
```

Alternatively it is possible to retrieve all the Documents in a Collection gradually.

``` ruby
myCollection.export batchSize: 3 # First three Documents of the Collection
myCollection.exportNext # Next three Documents
myCollection.exportNext # Next three Documents
```

<a name="ArangoDocument"></a>
## Arango::Document

An Arango::Document is an element of a Arango::Collection. Edges are Arango documents with "\_from" and "\_to" in their body.
You can create an ArangoCollection instance in one of the following way:

``` ruby
myDocument = myCollection.document name: "MyDocument"
myDocument = myCollection["MyDocument"]
myDocument = Arango::Document.new collection: myCollection, name: "MyDocument"
```

In the case you want to define a Edge, it is convenient to introduce the parameters "from" and "to" in the instance.

``` ruby
myEdge = Arango::Document.new name: "MyEdge", from: myDocA, to: myDocB
```

where myDocA and myDocB are the IDs of two Documents or are two Arango::Document instances.

During the creation of an Arango::Document instance, it is possible to define the body for the Document.

``` ruby
myDocument = Arango::Document.new body: {value:  17}, name: "MyDocument"
```

### Main methods

arangodb-driver provides several way to create a single Document.

``` ruby
myDocument.create                      # Create a new document
myDocument.retrieve                    # Retrieve Document
myDocument.update body: {value:  3}  # We update or add a value
myDocument.replace body: {value:  3} # We replace a value
myDocument.destroy                     # Destroy document
```

### Retrieve information

``` ruby
myDocument.collection # Retrieve Collection of the Document
myDocument.database   # Retrieve Database of the Document
myDocument.server     # Retrieve Server of the Document
myDocument.edges collection: myEdgeCollection  # Retrieve all myEdgeCollection edges connected with the Document
myDocument.any(myEdgeCollection) # Retrieve all myEdgeCollection edges connected with the Document
myDocument.in(myEdgeCollection)  # Retrieve all myEdgeCollection edges coming in the Document
myDocument.out(myEdgeCollection) # Retrieve all myEdgeCollection edges going out the Document
myEdge.from # Retrieve the document at the begin of the edge
myEdge.to   # Retrieve the document at the end of the edge
```

#### Example: how to navigate the edges

It is possible to navigate between edges and vertexes of a graph database.

Think for example that we have the following schema:
 * A --[class: a, name: aa]--> B
 * A --[class: a, name: bb]--> C
 * A --[class: b, name: cc]--> D
 * B --[class: a, name: dd]--> E

Then we have:

 * A.retrieve is A
 * A.edges(collection: a) is [aa, bb]
 * B.in(a) is [aa]
 * B.out(a) is [dd]
 * B.any(a) is [aa, dd] (aa in entry, dd in exit)
 * aa.from is A
 * aa.to is B

We can even do some combinations: for example A.out(a)[0].to.out(a)[0].to is E since:
 * A.out(a) is [aa]
 * A.out(a)[0] is aa
 * A.out(a)[0].to is B
 * A.out(a)[0].to.out(a) is [dd]
 * A.out(a)[0].to.out(a)[0] is dd
 * A.out(a)[0].to.out(a)[0].to is E

<a name="ArangoGraph"></a>
## Arango::Graph

ArangoGraph are used to manage Graphs. You can create an Arango::Graph instance in one of the following way.

``` ruby
myGraph = myDatabase.graph name: "MyGraph"
myGraph = Arango::Graph.new name: "MyGraph", database: myDatabase
```

### Main methods

``` ruby
myGraph.create   # create a new Graph
myGraph.retrieve # retrieve the Graph
myGraph.database # retrieve database of the Graph
myGraph.destroy  # destroy the Graph
```

### Manage Vertex Collections

``` ruby
myGraph.getVertexCollections # Retrieve all the vertexCollections of the Graph
myGraph.addVertexCollection collection: "myCollection"  # Add a Vertex Collection to our Graph
myGraph.removeVertexCollection collection: "myCollection"  # Remove a Vertex Collection to our Graph
```

### Manage Edge Collections

``` ruby
myGraph.edgeCollections # Retrieve all the edgeCollections of the Graph
myGraph.addEdgeCollections collection: "myEdgeCollection", from: "myCollectionA", to: "myCollectionB"  # Add an Edge Collection to our Graph
myGraph.replaceEdgeCollections collection: "myEdgeCollection", from: "myCollectionA", to: "myCollectionB"  # Replace an Edge Collection to our Graph
myGraph.removeEdgeCollections collection: "myEdgeCollection"  # Remove an Edge Collection to our Graph
```

<a name="ArangoVertex"></a>
<a name="ArangoEdge"></a>
## Arango::Vertex and Arango::Edge

Both these two classes inherit the class Arango::Document.
These two classes have been created since Arango::Database offers, in connection of the chosen graph, different HTTP requests to manage Vertexes and Edges. We recommend the reader to read carefully the section on [Arango::Document instances](#ArangoDocument) before to start to use Arango::Vertex and Arango::Edge instances.

### Arango::Vertex methods

Arango::Vertex inherit all the methods of Arango::Document class. The following one works similar to the one of Arango::Document Class but use different HTTP requests. For this reason the performance could be different.
To use Arango::Vertex, the Collection of the Vertex needs to be added either to the VertexCollections or to the EdgeCollections of the chosen Graph. And the Collection needs to have assigned the graph.

``` ruby
myCollection.graph = myGraph # Be sure that the collection is assigned to a Graph
myVertex = myCollection.vertex name: "newVertex", body: {value:  3} # If graph is not assigned, an Arango::Document will be created
myVertex = Arango::Vertex.new name: "newVertex", body: {value:  3},
  collection: myCollection # create a new instance
```

```   ruby
myVertex.create    # create a new Document in the Graph
myVertex.retrieve  # retrieve a Document
myVertex.graph     # retrieve Graph of the Document
myVertex.replace body: {value:  6} # replace the Document
myVertex.update  body: {value:  6} # update the Document
myVertex.destroy   # delete the Document
```

### Arango::Edge methods

Arango::Edge inherit all the methods of Arango::Document class. The following one works similar to the one of Arango::Document Class but use a different HTTP request. For this reason the performance could be different.
To use Arango::Edge, the Collection of the Edge needs to be added to the EdgeCollections of the chosen Graph.

``` ruby
myEdgeCollection.graph = myGraph
myEdge = myCollection.edge name: "newEdge", body: {value:  3}, from: myArangoDocument1, to: myArangoDocument2 # If graph is not assigned, an Arango::Document will be created
```

```   ruby
myEdge.create   # create a new Document of type Edge in the Graph
myEdge.retrieve # retrieve a Document
myEdge.graph    # Retrieve Graph  of the Document
myEdge.replace body: {value:  6} # replace the Document
myEdge.update  body: {value:  6} # update the Document
myEdge.destroy  # delete the Document
```

<a name="ArangoTraversal"></a>
## Arango::Traversal

Arango::Traversal is used to administrate the traversals.
Arango::Traversal needs to know the vertex from where the traversal starts, the direction the traversal is going and either the Graph or the EdgeCollection we want to analyze.


``` ruby
myTraversal = myVertex.traversal   # Start traversal from myVertex
myTraversal = myDocument.traversal # Start traversal from myDocument
myTraversal = ArangoTraversal.new database: myDatabase, startVertex: myVertex # create instance
```

``` ruby
myTraversal.vertex = myVertex # define starting Vertex
myTraversal.edgeCollection = myEdgeCollection # define used Edge
myTraversal.in      # Direction is in
myTraversal.out     # Direction is out
myTraversal.any     # Direction is in and out
myTraversal.min = 1 # Define how minimum deep we want to go with the traversal
myTraversal.max = 3 # Define how maximum deep we want to go with the traversal
```

After the traversal is setup, you can execute it:

``` ruby
myTraversal.execute
```

<a name="ArangoUser"></a>
## Arango::User

Arango::User manages the users.
To initialize an user:

``` ruby
myUser = server.user name: "MyUser", password: "password"
myUser = Arango::User.new user: "MyUser", password: "password", server: server
```

### User management

``` ruby
myUser.retrieve               # Retrieve User
myUser["MyDatabase"]          # Retrieve database if the user can access it
myUser.database("MyDatabase") # Retrieve database if the user can access it
myUser.create                 # Create a new User
myUser.replace active: false  # Replace User
myUser.update active: false   # Update User
myUser.destroy               # Delete User
```

### Database management

``` ruby
myUser.databases # List of databases can access
myUser.addDatabaseAccess grant: "rw", database: myDatabase
myUser.grant          database: myDatabase # Grant access to a database
myUser.revoke         database: myDatabase # Revoke access to a database
myUser.databaseAccess database: myDatabase # Check permission level of an User
myUser.addCollectionAccess grant: "rw", database: myDatabase, collection: myCollection
myUser.revokeCollectionAccess database: myDatabase, collection: myCollection
myUser.collectionAccess database: myDatabase, collection: myCollection
```

You can manage the user permissions from the database or from the collection too.

``` ruby
myDatabase.check_user(myUser)
myDatabase.addUserAccess(grant: "rw", user: myUser)
myDatabase.revokeUserAccess(user: myUser)
myDatabase.userAccess(user: myUser)
myCollection.check_user(myUser)
myCollection.addUserAccess(grant: "rw", user: myUser)
myCollection.revokeUserAccess(user: myUser)
myCollection.userAccess(user: myUser)
```

<a name="ArangoIndex"></a>
## Arango::Index

Arango::Index manages the indexes.
To initialize an index:

``` ruby
myIndex = myCollection.index fields: "num", unique: false, id: "myIndex"
myIndex = Arango::Index.new  fields: "num", unique: false, id: "myIndex", collection: myCollection
```

### Index management

``` ruby
myIndex.retrieve # Retrieve Index
myIndex.create # Create a new Index
myIndex.destroy # Delete Index
```

<a name="ArangoTransaction"></a>
## Arango::Transaction

Transactions are managed by Arango::Transaction.

``` ruby
action = "function(){ var db = require('@arangodb').db; db.MyCollection.save({}); return db.MyCollection.count(); }"
myTransaction = myDatabase.transaction action: action
myTransaction = Arango::Transaction.new action: action, database: myDatabase
```

``` ruby
myTransaction.addWrite(myCollection) # Add write collection
myTransaction.addRead(myCollection) # Add read collection
myArangoTransaction.execute # Return the result of the execution
```

<a name="ArangoTask"></a>
## Arango::Task

Tasks are managed by ArangoTask.

``` ruby
command = "(function(params) { require('@arangodb').print(params); })(params)"
myTask = myDatabase.task id: "mytaskid", name: "MyTaskID", command: command, params: {foo:  "bar", bar:  "foo"}, period: 2
myTask = Arango::Task.new id: "mytaskid", name: "MyTaskID", command: command, params: {foo:  "bar", bar:  "foo"}, period: 2, database: myDatabase
```

``` ruby
myArangoTask.create   # Create a new Task
myArangoTask.retrieve # Retrieve a Task
myArangoTask.destroy  # Delete a Task
```

<a name="ArangoReplication"></a>
## Arango::Replication

Replication is useful to create back up copy of your database or to have a master-slave relationship between two databases.

Remember: the used database is the one where the data will be written (the slave) and the remote database will be the master one.

Use with caution since the data in the slave database will be deleted.

To setup our Slave Server and Master Database use a similar command.

``` ruby
myReplication = slaveDatabase.replication(master: masterDatabase)
myReplication = masterDatabase.replication_as_master(slave: slaveDatabase)
myReplication = Arango::Replication.new master: masterDatabase, slave: slaveDatabase
```

Than to do a simple syncronization uses;

``` ruby
myReplication.sync    # Sync master - slave database
```

To retrieve other information arangodb-driver provides the following methods:

``` ruby
myReplication.logger       # Returns the current state of the server's replication logger
myReplication.loggerFollow # Returns data from the server's replication log.
myReplication.firstTick    # Return the first available tick value from the server
myReplication.rangeTick # Returns the currently available ranges of tick values for all currently available WAL logfiles.
myReplication.serverId  # Returns the servers id.
```

### Relation Master-Slave

To enslave a Server in relation to another Database use the following command:

``` ruby
myReplication.enslave
```

To manage the Configuration of a Master-Slave Replication you can use the following commands:

``` ruby
myReplication.start   # Start replication
myReplication.configuration # check the Configuration of the Replication
myReplication.state   # check the status of the Replication
myReplication.stop    # stop the Replication
myReplication.modify  # modify the Configuration of the Replication (you can modify only a stopped Replication)
```

## Arango::Batch

To create a batch request, you can use arangodb-driver::Batch object. This permit to do multiple requests with one single call to the API.

To create a batch use one of the following way:

``` ruby
batch = server.batch
batch = Arango::Batch.new(server: server)
```

To add a queries to the batch request you can use the brutal way:

``` ruby
batch.queries = [
  {
    type: "POST",
    address: "/_db/MyDatabase/_api/collection",
    body: {name: "newCOLLECTION"},
    id: "1"
  },
  {
    type: "GET",
    address: "/_api/database",
    id: "2"
  }
]
```

Or the Ruby way (the id will be handled by the system, if not specified):

``` ruby
batch = server.batch
batch.addQuery(method: "POST", address: "/_db/MyDatabase/_api/collection",
  body: {name: "newCOLLECTION"})
batch.addQuery(method: "GET", address: "/_api/database")
```

In both the cases the queries will be stored in an hash with key the id of the query and as value the query.
This query can be handled with the following methods:

``` ruby
batch.to_h # Retrieve an hash version of the instance
batch.modifyQuery(id: "1", method: "GET", address: "/_db/MyDatabase/_api/collection/newCOLLECTION") # Modify the Query with id "1"
batch.removeQuery(id: "1") # Remove query
```

To execute the query use:

``` ruby
batch.execute
```

To manage how the server handle the batch, Arango::Server offers the following functions:

``` ruby
server.createDumpBatch ttl: 10 # Create a new dump batch with 10 second time-to-live (return id of the dumpBatch)
server.prolongDumpBatch id: idDumpBatch, ttl: 20 # Prolong the life of a batch for 20 seconds
server.destroyDumpBatch id: idDumpBatch # Delete a selected batch
```

<a name="ArangoView"></a>
## Arango::View

Views are managed by Arango::View.

``` ruby
myView = myDatabase.view name: "MyView"
myView = Arango::View.new name: "MyView", database: myDatabase
```

``` ruby
myView.addLink(collection: myCollection) # Add a collection to the link
myView.retrieve               # Retrieve view
myView.create                 # Create a view
myView.replaceProperties      # Replace properties
myView.updateProperties       # Update properties
myView.rename name: "MyView2" # Change name
myView.properties             # Check properties
myView.destroy                # Delete view
```

<a name="ArangoFoxx"></a>
## Arango::Foxx

Views are managed by Arango::Foxx. This instance of Foxx is untested.

``` ruby
myFoxx = myDatabase.foxx mount: address
myFoxx = Arango::Foxx.new mount: address, database: myDatabase
```

``` ruby
myFoxx.retrieve # Retrieve foxx
myView.create   # Create a foxx
myFoxx.update   # Update foxx
myFoxx.replace  # Replace foxx
myFoxx.destroy  # Delete foxx
```

Other methods

``` ruby
myFoxx.retrieveConfiguration
myView.updateConfiguration body: body
myFoxx.replaceConfiguration body: body
myFoxx.retrieveDependencies
myFoxx.updateDependencies body: body
myFoxx.replaceDependencies body: body
myFoxx.scripts
myFoxx.run_script name: "test"
myFoxx.tests
myFoxx.enableDevelopment
myFoxx.disableDevelopment
myFoxx.readme
myFoxx.swagger
myFoxx.download path: path
myFoxx.commit body: body
```

<a name="ArangoCache"></a>
## Arango::Cache

Arango::Cache is to manage arangodb-driver Cache (NOT ArangoDB cache) and it helps you to manage your documents around your code. In this way if you update an Arango::Document in your code, it will updated everywhere.
An Arango::Cache instance is created together with the initialization of a server instance with active_cache true.

``` ruby
cache = server.cache # Arango::Cache instance
cache.max            # Max number of variable stored in the cache
cache.updateMax(type: :document, val: 400) # Update how many documents store in the cache
cache.clear          # Clear cache
cache.to_h           # Hash of the cache
```

NB: If you insert a max value higher than the quantity of elements in the Cache, then the first elements in excess will be removed from the Cache.

If the limit of the Cache for one type is reached, then the first element cached of that type will be deleted from the Cache.


<a name="ArangoError"></a>
## Arango::Error

Error from arangodb-driver are managed by Arango::Error.
Each arangodb-driver error is provided of a code and a message. The list of code can be find in the file lib/Error.rb

``` ruby
begin
  Arango::Collection.new name: "Test", database: not_a_database
rescue Arango::Error => e
  e.message # Message of the error
  e.code    # arangodb-driver code, each arangodb-driver errors provides a list of errors
  e.data    # More information about the error
  e.to_h    # Hash version of the error
end
```

Arango::Error has a children class called Arango::ErrorDB to handle Errors coming from wrong HTTP requests.

``` ruby
begin
  Arango::Collection.new(name: "DuplicateCollection", database: myDatabase).create
rescue Arango::Error => e
  e.message  # Message of the error
  e.code     # HTTP error code
  e.data     # More information about the error
  e.errorNum # ArangoDB errorNum code
  e.action   # Type of request done to ArangoDB (POST, GET, ...)
  e.url      # URL requested to ArangoDB
  e.request  # Request made to ArangoDB
  e.to_h     # Hash version of the error
end
```

<a name="testing"></a>
## Testing

To test arangodb-driver you can use:

``` ruby
rspec spec/arangoRB_helper.rb
ruby examples/year.rb
ruby examples/year2.rb
```

Remember however the following:
* Setup the correct server in lib/spec_helper.rb and in the examples
* The test examples/year2.rb should run much after the test examples/year.rb, since the last test is dependent from the conclusion of the first test (that is running in async).

<a name="differences"></a>
