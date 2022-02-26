require_relative 'spec_helper'

describe Arango::Graph do
  before :all do
    @server = connect
    begin
      @server.delete_database(name: "GraphDatabase")
    rescue
    end
    @database = @server.create_database(name: "GraphDatabase")
  end

  before :each do
    begin
      @database.delete_graph(name: 'MyGraph')
    rescue
    end
  end

  after :each do
    begin
      @database.delete_graph(name: 'MyGraph')
    rescue
    end
  end

  after :all do
    @server.delete_database(name: "GraphDatabase")
  end

  context "Database" do
    it "new_graph" do
      graph = @database.new_graph name: "MyGraph"
      expect(graph.name).to eq "MyGraph"
    end

    it "create_graph" do
      graph = @database.create_graph name: "MyGraph"
      expect(graph.name).to eq "MyGraph"
    end

    it "get_graph" do
      @database.create_graph name: "MyGraph"
      graph = @database.get_graph(name: "MyGraph")
      expect(graph.name).to eq "MyGraph"
    end

    it "list_graphs" do
      @database.create_graph name: "MyGraph"
      list = @database.list_graphs
      expect(list).to include("MyGraph")
    end

    it "delete_graph" do
      @database.create_graph name: "MyGraph"
      list = @database.list_graphs
      expect(list).to include("MyGraph")
      @database.delete_graph(name: "MyGraph")
      list = @database.list_graphs
      expect(list).not_to include("MyGraph")
    end

    it "graph_exists?" do
      @database.create_graph name: "MyGraph"
      result = @database.graph_exists?(name: "MyGraph")
      expect(result).to be true
      result = @database.graph_exists?(name: "StampGraph")
      expect(result).to be false
    end

    it "all_graphs" do
      @database.create_graph name: "MyGraph"
      graph = @database.all_graphs
      list = graph.map(&:name)
      expect(list).to include("MyGraph")
      expect(graph.first.class).to be Arango::Graph::Base
    end
  end

  context "Arango::Graph::Base itself" do
    it "new" do
      graph = Arango::Graph::Base.new(name: "MyGraph", database: @database)
      expect(graph.name).to eq "MyGraph"
    end

    it "create graph" do
      Arango::Graph::Base.new(name: "MyGraph", database: @database).create
      graph = Arango::Graph::Base.get(name: "MyGraph", database: @database)
      expect(graph.name).to eq "MyGraph"
    end

    it "fails to create a duplicate Graph" do
      Arango::Graph::Base.new(name: "MyGraph", database: @database).create
      error = nil
      begin
        Arango::Graph::Base.new(name: "MyGraph", database: @database).create
      rescue Arango::Error => e
        error = e.message
      end
      expect(error).to be_a String
    end

    it "delete" do
      Arango::Graph::Base.new(name: "MyGraph", database: @database).create
      graph = Arango::Graph::Base.get(name: "MyGraph", database: @database)
      graph.delete
      message = nil
      begin
        Arango::Graph::Base.get(name: "MyGraph", database: @database)
      rescue Arango::Error => e
        message = e.message
      end
      expect(message).to include 'not found'
    end

    it "revision" do
      graph = Arango::Graph::Base.new(name: "MyGraph", database: @database).create
      expect(graph.revision).to be_a String
    end

  #
  # context "#info" do
  #   it "info graph" do
  #     myGraph = @myGraph.retrieve
  #     expect(myGraph.name).to eq "MyGraph"
  #   end
  # end
  #
  # # it "list graphs" do
  # #   list = @database.graphs
  # #   expect(list.length).to be 0
  # # end
  # #
  # context "#manageVertexCollections" do
  #   it "add VertexCollection" do
  #     errors = []
  #     begin
  #       @myGraph.remove_edge_definition collection: "MyEdgeCollection"
  #     rescue Arango::Error => e
  #       errors << e.error_num
  #     end
  #     error = ""
  #     begin
  #       myGraph = @myGraph.add_vertex_collection collection: "MyCollection"
  #     rescue Arango::ErrorDB => e
  #       errors << e.error_num
  #     end
  #     @myGraph.remove_vertex_collection collection: "MyCollection"
  #     myGraph = @myGraph.add_vertex_collection collection: "MyCollection"
  #     expect([myGraph.orphan_collections[0].name, errors]).to eq ["MyCollection", [1930, 1938]]
  #   end
  #
  #   it "retrieve VertexCollection" do
  #     myGraph = @myGraph.vertex_collections
  #     expect(myGraph[0].name).to eq "MyCollection"
  #   end
  #
  #   it "remove VertexCollection" do
  #     myGraph = @myGraph.remove_vertex_collection collection: "MyCollection"
  #     expect(myGraph.orphan_collections[0]).to eq nil
  #   end
  # end
  #
  # context "#manageEdgeCollections" do
  #   it "add EdgeCollection" do
  #     myGraph = @myGraph.add_edge_definition collection: "MyEdgeCollection", from: "MyCollection", to: @myCollectionB
  #     expect(myGraph.edge_definitions[0][:from][0].name).to eq "MyCollection"
  #   end
  #
  #   it "retrieve EdgeCollection" do
  #     myGraph = @myGraph.get_edge_collections
  #     expect(myGraph[0].name).to eq "MyEdgeCollection"
  #   end
  #
  #   it "retrieve EdgeCollection" do
  #     myGraph = @myGraph.edge_definitions
  #     expect(myGraph[0][:collection].name).to eq "MyEdgeCollection"
  #   end
  #
  #   it "replace EdgeCollection" do
  #     myGraph = @myGraph.replace_edge_definition collection: @myEdgeCollection, from: "MyCollection", to: "MyCollection"
  #     expect(myGraph.edge_definitions[0][:to][0].name).to eq "MyCollection"
  #   end
  #
  #   it "remove EdgeCollection" do
  #     myGraph = @myGraph.remove_edge_definition collection: "MyEdgeCollection"
  #     expect(myGraph.edge_definitions[0]).to eq nil
  #   end
  # end
  #
  # context "#destroy" do
  #   it "delete graph" do
  #     myGraph = @myGraph.destroy
  #     expect(myGraph).to be true
  #   end
  # end
  end
end
