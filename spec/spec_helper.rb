require "ostruct"
require "benchmark/ips"
require "rspec"
require "simplecov"
SimpleCov.start rescue nil
require "arango-driver"

module Helpers
	def connect
		Arango.connect_to_server username: "root", password: "", host: "localhost", port: "8529"
	end
end

RSpec.configure do |config|
  config.include Helpers
	config.color = true
	config.before :all do
		# @myDatabase    = @server.database(name: "MyDatabase")
		# @myDatabase.create
		# @myGraph       = @myDatabase.graph(name: "MyGraph").create
		# @myCollection  = @myDatabase.collection(name: "MyCollection").create
		# @myCollectionB = @myDatabase.collection(name: "MyCollectionB").create
		# @myDocument    = @myCollection.document(name: "FirstDocument", body: {Hello: "World", num: 1}).create
		# @myEdgeCollection = @myDatabase.collection(name: "MyEdgeCollection", type: "Edge").create
		# @myGraph.add_vertex_collection collection: "MyCollection"
		# @myGraph.add_edge_definition collection: "MyEdgeCollection", from: "MyCollection", to: "MyCollection"
		# @myAQL = @myDatabase.aql query: "FOR u IN MyCollection RETURN u.num"
		# @myDoc = @myCollection.create_documents document: [{num: 1, _key: "FirstKey"},
		# 	{num: 1}, {num: 1}, {num: 1}, {num: 1}, {num: 1},
		# 	{num: 1}, {num: 2}, {num: 2}, {num: 2}, {num: 3},
		# 	{num: 2}, {num: 5}, {num: 2}]
		# @myCollection.graph = @myGraph
		# @myEdgeCollection.graph = @myGraph
		# @myVertex = @myCollection.vertex(body: {Hello: "World", num: 1}, name: "FirstVertex").create
		# @vertexA = @myCollection.vertex(body: {Hello: "World", num: 1}, name: "Second_Key").create
	  # @vertexB = @myCollection.vertex(body: {Hello: "Moon", num: 2}).create
	  # @myEdge = @myEdgeCollection.edge(from: @vertexA, to: @vertexB).create
		# @myIndex = @myCollection.index(unique: false, fields: "num", type: "hash", id: "MyIndex").create
		# @myTraversal = @vertexA.traversal
		# @myUser = @server.user(name: "MyUser")
		# begin
		# 	@myUser.destroy
		# rescue Arango::Error => e
		# end
		# @myUser.create
		#
		#
		# @myView = @myDatabase.view name: "MyView"
	end

	config.after(:all) do
		# [@myIndex, @myDatabase, @myUser].each do |c|
		# 	begin
		# 		c.destroy unless c.nil?
		# 	rescue Arango::Error => e
		# 	end
		# end
	end
end
