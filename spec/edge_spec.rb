require_relative 'spec_helper'

describe Arango::Edge do
  before :all do
    @server = connect
    begin
      @server.delete_database(name: "EdgeDatabase")
    rescue
    end
    @database = @server.create_database(name: "EdgeDatabase")
  end

  before :each do
    begin
      @database.delete_collection(name: "DocumentCollection")
    rescue
    end
    begin
      @database.delete_collection(name: "EdgeCollection")
    rescue
    end
    @collection = @database.create_collection(name: "DocumentCollection")
    @edge_collection = @database.create_edge_collection(name: "EdgeCollection")
    @doc_a = @collection.create_document(attributes: {a: 'a', name: 'a'})
    @doc_b = @collection.create_document(attributes: {b: 'b', name: 'b'})
  end

  after :each do
    begin
      @database.delete_collection(name: "DocumentCollection")
    rescue
    end
    begin
      @database.delete_collection(name: "EdgeCollection")
    rescue
    end
  end

  after :all do
    @server.delete_database(name: "EdgeDatabase")
  end

  context "EdgeCollection" do
    it "new_edge" do
      edge = @edge_collection.new_edge(from: @doc_a, to: @doc_b)
      expect(edge.from).to eq @doc_a
      expect(edge.from_id).to eq @doc_a.id
      expect(edge.to).to eq @doc_b
      expect(edge.to_id).to eq @doc_b.id
    end

    it "create_edge" do
      edge = @edge_collection.create_edge(from: @doc_a, to: @doc_b)
      expect(edge.attributes[:_from]).to eq @doc_a.id
    end

    it "new_edge.create" do
      edge = @edge_collection.new_edge(from: @doc_a.id, to: @doc_b.id)
      edge.create
      expect(edge.from_id).to eq @doc_a.id
    end

    it "create_edge with key" do
      edge = @edge_collection.create_edge(attributes: { key: "myKey1", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      expect(edge.edge_collection.name).to eq "EdgeCollection"
      edge = @edge_collection.create_edge(key: "myKey2", attributes: { test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      expect(edge.edge_collection.name).to eq "EdgeCollection"
    end

    it "create_edges" do
      edges = @edge_collection.create_edges([{ test1: 'value', test2: 100, from: @doc_a.id, to: @doc_b.id },
                                             { test3: 'value', test4: 100, from: @doc_b.id, to: @doc_a.id }])
      expect(edges.size).to eq(2)
      expect(@edge_collection.edge_exists?(key: edges.first.key)).to be true
      expect(@edge_collection.edge_exists?(key: edges.last.key)).to be true
      expect(edges.first.edge_collection.name).to eq "EdgeCollection"
    end

    it "create_edges by key" do
      edges = @edge_collection.create_edges([{ key: 'key1', from: @doc_a.id, to: @doc_b.id },
                                             { key: 'key2', from: @doc_b.id, to: @doc_a.id }])
      expect(edges.size).to eq(2)
      expect(@edge_collection.edge_exists?(key: edges.first.key)).to be true
      expect(@edge_collection.edge_exists?(key: edges.last.key)).to be true
      expect(edges.first.edge_collection.name).to eq "EdgeCollection"
    end

    it "all_edges" do
      @edge_collection.create_edge(attributes: { key: "myKey1", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(key: "myKey2", attributes: { test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edges = @edge_collection.all_edges
      expect(edges.size).to eq 2
    end

    it "all_edges with limits" do
      @edge_collection.create_edge(attributes: { key: "myKey1", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(key: "myKey2", attributes: { test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edges = @edge_collection.all_edges(limit: 1, offset: 1)
      expect(edges.size).to eq 1
    end

    it "list_edges" do
      @edge_collection.create_edge(attributes: { key: "myKey1", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(key: "myKey2", attributes: { test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edges = @edge_collection.list_edges
      expect(edges.size).to eq 2
    end

    it "list_edges with limits" do
      @edge_collection.create_edge(attributes: { key: "myKey1", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(key: "myKey2", attributes: { test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edges = @edge_collection.list_edges(limit: 1, offset: 1)
      expect(edges.size).to eq 1
    end

    it "all_edges" do
      @edge_collection.create_edge(attributes: { key: "myKey1", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(key: "myKey2", attributes: { test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edges = @edge_collection.all_edges
      expect(edges.size).to eq 2
    end

    it "all_edges with limits" do
      @edge_collection.create_edge(attributes: { key: "myKey1", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(key: "myKey2", attributes: { test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edges = @edge_collection.all_edges(limit: 1, offset: 1)
      expect(edges.size).to eq 1
    end

    it "get_edge" do
      @edge_collection.create_edge(attributes: { key: "superb", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edge = @edge_collection.get_edge(key: 'superb')
      expect(edge.test1).to eq 'value'
    end

    it "get_edge by example" do
      @edge_collection.create_edge(attributes: { key: "superb", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edge = @edge_collection.get_edge(attributes: { test2: 100})
      expect(edge.test1).to eq 'value'
    end

    it "get_edges" do
      @edge_collection.create_edge(attributes: { key: "1234567890", test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(key: "1234567891", attributes: { test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      edges = @edge_collection.get_edges(['1234567890', '1234567891'])
      expect(edges.size).to eq 2
    end

    it "get_edges by example" do
      @edge_collection.create_edge(attributes: { key: '1234567890', test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(attributes: { key: '1234567891', test1: 'value', test2: 200}, from: @doc_a.id, to: @doc_b.id)
      edges = @edge_collection.get_edges([{test2: 100}, {test2: 200}])
      expect(edges.size).to eq 2
    end

    it "delete_edge" do
      edge = @edge_collection.create_edge(attributes: { key: '1234567890', test1: 'value', test2: 100}, from: @doc_a.id, to: @doc_b.id)
      expect(@edge_collection.list_edges).to include(edge.key)
      @edge_collection.delete_edge(key: edge.key)
      expect(@edge_collection.list_edges).not_to include(edge.key)
    end

    it "delete_edges" do
      @edge_collection.create_edge(key: '1234567890', attributes: { test1: 'value', test2: 100 }, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.create_edge(attributes: { key: '1234567891', test1: 'value', test2: 100 }, from: @doc_a.id, to: @doc_b.id)
      @edge_collection.delete_edges(['1234567890', '1234567891'])
      expect(@edge_collection.size).to eq 0
    end

    it "document_exists?" do
      expect(@edge_collection.edge_exists?(key: 'whuahaha')).to be false
      @edge_collection.create_edge(key: 'whuahaha', from: @doc_a.id, to: @doc_b.id)
      expect(@edge_collection.edge_exists?(key: 'whuahaha')).to be true
    end
  end

  context "Arango::Edge itself" do
    it "create a new Edge instance " do
      edge = Arango::Edge::Base.new key: "myKey", from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection
      expect(edge.edge_collection.name).to eq "EdgeCollection"
    end

    it "create a new Edge in the EdgeCollection" do
      edge = Arango::Edge::Base.new(attributes: {Hello: "World", num: 1}, from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection).create
      expect(edge.Hello).to eq "World"
    end

    it "create a duplicate Edge" do
      error = ""
      begin
        Arango::Edge::Base.new(key: 'mykey', from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection).create
        Arango::Edge::Base.new(key: 'mykey', from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection).create
        raise
      rescue Arango::Error => e
        expect(e.message).to be_a String
      end
    end

    it "delete a Edge" do
      edge = Arango::Edge::Base.new(key: 'mykey', from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection).create
      result = edge.delete
      expect(result).to eq nil
      expect(Arango::Edge::Base.exists?(key: 'mykey', edge_collection: @edge_collection)).to be false
    end

    it "update" do
      edge = Arango::Edge::Base.new(key: 'mykey', from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection).create
      edge.time = 13
      edge.update
      expect(edge.time).to eq 13
      edge = Arango::Edge::Base.get(key: 'mykey', edge_collection: @edge_collection)
      expect(edge.time).to eq 13
    end

    it "replace" do
      edge = Arango::Edge::Base.new(attributes: {key: 'mykey', test: 1}, from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection).create
      edge.attributes = {value: 3}
      edge.replace
      expect(edge.value).to eq 3
      expect(edge.attribute_test).to be_nil
    end

    it "get Edge" do
      edge = Arango::Edge::Base.new(attributes: {key: 'mykey', test: 1}, from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection).create
      edge.test = 2
      edge.reload
      expect(edge.test).to eq 1
    end

    it "same_revision?" do
      edge = Arango::Edge::Base.new(key: 'mykey', from: @doc_a.id, to: @doc_b.id, edge_collection: @edge_collection).create
      edge_two = Arango::Edge::Base.get(key: 'mykey', edge_collection: @edge_collection)
      expect(edge.same_revision?).to be true
      expect(edge_two.same_revision?).to be true
      edge.time = 13
      edge.update
      expect(edge.same_revision?).to be true
      expect(edge_two.same_revision?).to be false
    end

    # it "retrieve Edge" do
    #   my_document = @my_edge.retrieve
    #   expect(my_document.collection.name).to eq "MyEdgeCollection"
    # end
    #
    # it "replace" do
    #   a = @collection.vertex(body: {Hello: "World"}).create
    #   b = @collection.vertex(body: {Hello: "World!!"}).create
    #   my_document = @my_edge.replace body: {_from: a.id, _to: b.id}
    #   expect(my_document.body[:_from]).to eq a.id
    # end
    #
    # it "update" do
    #   cc = @collection.vertex(body: {Hello: "World!!!"}).create
    #   my_document = @my_edge.update body: {_to: cc.id}
    #   expect(my_document.body[:_to]).to eq cc.id
    # end
    #
    # it "delete a Edge" do
    #   result = @my_edge.delete
    #   expect(result).to eq true
    # end
  end
end
