require_relative 'spec_helper'

describe Arango::Document do
  before :all do
    @server = connect
    begin
      @server.delete_database(name: "DocumentDatabase")
    rescue
    end
    @database = @server.create_database(name: "DocumentDatabase")
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
    @server.delete_database(name: "DocumentDatabase")
  end

  context "Collection" do
    it "new_document" do
      document = @collection.new_document(attributes: { test1: 'value', test2: 100})
      expect(document.collection.name).to eq "DocumentCollection"
    end

    it "create_document" do
      document = @collection.create_document(attributes: { test1: 'value', test2: 100})
      expect(document.collection.name).to eq "DocumentCollection"
    end

    it "create_document with key" do
      document = @collection.create_document(attributes: { key: "myKey1", test1: 'value', test2: 100})
      expect(document.collection.name).to eq "DocumentCollection"
      document = @collection.create_document(key: "myKey2", attributes: { test1: 'value', test2: 100})
      expect(document.collection.name).to eq "DocumentCollection"
    end

    it "create_documents" do
      documents = @collection.create_documents([{ test1: 'value', test2: 100 }, { test3: 'value', test4: 100 }])
      expect(documents.size).to eq(2)
      expect(@collection.document_exists?(attributes: documents.first)).to be true
      expect(@collection.document_exists?(attributes: documents.last)).to be true
      expect(documents.first.collection.name).to eq "DocumentCollection"
    end

    it "create_documents with key" do
      documents = @collection.create_documents([{ key: 'key1', test1: 'value', test2: 100 }, { key: 'key2', test3: 'value', test4: 100 }])
      expect(documents.size).to eq(2)
      expect(@collection.document_exists?(attributes: documents.first)).to be true
      expect(@collection.document_exists?(attributes: documents.last)).to be true
      expect(documents.first.collection.name).to eq "DocumentCollection"
    end

    it "create_documents by key" do
      documents = @collection.create_documents(['key1', 'key2'])
      expect(documents.size).to eq(2)
      expect(@collection.document_exists?(attributes: documents.first)).to be true
      expect(@collection.document_exists?(attributes: documents.last)).to be true
      expect(documents.first.collection.name).to eq "DocumentCollection"
    end

    it "all_documents" do
      @collection.create_document(attributes: { name: 'test1', a: 'a'})
      @collection.create_document(attributes: { name: 'test2', b: 'b'})
      documents = @collection.all_documents
      expect(documents.size).to eq 2
    end

    it "all_documents with limits" do
      @collection.create_document(attributes: { name: 'test1', a: 'a'})
      @collection.create_document(attributes: { name: 'test2', b: 'b'})
      documents = @collection.all_documents(limit: 1, offset: 1)
      expect(documents.size).to eq 1
    end

    it "list_documents" do
      @collection.create_document(attributes: { name: 'test1', a: 'a'})
      @collection.create_document(attributes: { name: 'test2', b: 'b'})
      documents = @collection.list_documents
      expect(documents.size).to eq 2
    end

    it "list_documents with limits" do
      @collection.create_document(attributes: { name: 'test1', a: 'a'})
      @collection.create_document(attributes: { name: 'test2', b: 'b'})
      documents = @collection.list_documents(limit: 1, offset: 1)
      expect(documents.size).to eq 1
    end

    it "get_document" do
      @collection.create_document(attributes: { key: 'superb', test1: 'value', test2: 100})
      document = @collection.get_document(key: 'superb')
      expect(document.test1).to eq 'value'
    end

    it "get_document by example" do
      @collection.create_document(attributes: { test1: 'value', test2: 100})
      document = @collection.get_document(attributes: { test2: 100})
      expect(document.test1).to eq 'value'
    end

    it "get_documents" do
      @collection.create_document(attributes: { key: '1234567890', test1: 'value', test2: 100})
      @collection.create_document(attributes: { key: '1234567891', test1: 'value', test2: 200})
      documents = @collection.get_documents(['1234567890', '1234567891'])
      expect(documents.size).to eq 2
    end

    it "get_documents by example" do
      @collection.create_document(attributes: { key: '1234567890', test1: 'value', test2: 100})
      @collection.create_document(attributes: { key: '1234567891', test1: 'value', test2: 200})
      documents = @collection.get_documents([{test2: 100}, {test2: 200}])
      expect(documents.size).to eq 2
    end

    it "delete_document" do
      document = @collection.create_document(attributes: {})
      expect(@collection.list_documents).to include(document.key)
      @collection.delete_document(key: document.key)
      expect(@collection.list_documents).not_to include(document.key)
    end

    it "delete_documents" do
      @collection.create_document(key: '1234567890', attributes: { test1: 'value', test2: 100 })
      @collection.create_document(attributes: { key: '1234567891', test1: 'value', test2: 100 })
      @collection.delete_documents(['1234567890', '1234567891'])
      expect(@collection.size).to eq 0
    end

    it "document_exists?" do
      expect(@collection.document_exists?(key: 'whuahaha')).to be false
      @collection.create_document(key: 'whuahaha')
      expect(@collection.document_exists?(key: 'whuahaha')).to be true
    end
  end

  context "Arango::Document itself" do
    it "create a new Document instance " do
      document = Arango::Document::Base.new key: "myKey", collection: @collection
      expect(document.collection.name).to eq "DocumentCollection"
    end

    it "create a new Document in the Collection" do
      document = Arango::Document::Base.new(attributes: {Hello: "World", num: 1}, collection: @collection).create
      expect(document.Hello).to eq "World"
    end

    it "create a duplicate Document" do
      error = nil
      begin
        Arango::Document::Base.new(key: 'mykey', collection: @collection).create
        Arango::Document::Base.new(key: 'mykey', collection: @collection).create
      rescue Arango::Error => e
        error = e.message
      end
      expect(error).to be_a String
    end

    it "delete a Document" do
      document = Arango::Document::Base.new(key: 'mykey', collection: @collection).create
      result = document.delete
      expect(result).to eq nil
      expect(Arango::Document::Base.exists?(key: 'mykey', collection: @collection)).to be false
    end

    it "update" do
      document = Arango::Document::Base.new(key: 'mykey', collection: @collection).create
      document.time = 13
      document.update
      expect(document.time).to eq 13
      document = Arango::Document::Base.get(key: 'mykey', collection: @collection)
      expect(document.time).to eq 13
    end

    it "replace" do
      document = Arango::Document::Base.new(attributes: {key: 'mykey', test: 1}, collection: @collection).create
      document.attributes = {value: 3}
      document.replace
      expect(document.value).to eq 3
      expect(document.attribute_test).to be_nil
    end

    it "reload Document" do
      document = Arango::Document::Base.new(attributes: {key: 'mykey', test: 1}, collection: @collection).create
      document.test = 2
      document.reload
      expect(document.test).to eq 1
    end

    it "same_revision?" do
      document = Arango::Document::Base.new(key: 'mykey', collection: @collection).create
      document_two = Arango::Document::Base.get(key: 'mykey', collection: @collection)
      expect(document.same_revision?).to be true
      expect(document_two.same_revision?).to be true
      document.time = 13
      document.update
      expect(document.same_revision?).to be true
      expect(document_two.same_revision?).to be false
    end

    # it "search Documents by match" do
    #   info = collection.documents_match match: {num: 1}
    #   expect(info.length).to eq 3
    # end
    #
    # it "search Document by match" do
    #   info = collection.document_match match: {num: 1}
    #   expect(info.collection.name).to eq "DocumentCollection"
    # end
    #
    # it "search Document by key match" do
    #   docs = collection.create_documents document: [{_key: "ThisIsATest1", test: "fantastic"}, {_key: "ThisIsATest2"}]
    #   result = collection.documents_by_keys keys: ["ThisIsATest1", docs[1]]
    #   expect(result[0].body[:test]).to eq "fantastic"
    # end
    #
    # it "remove Document by key match" do
    #   docs = collection.create_documents document: [{_key: "ThisIsATest3", test: "fantastic"}, {_key: "ThisIsATest4"}]
    #   result = collection.remove_by_keys keys: ["ThisIsATest3", docs[1]]
    #   expect(result[:removed]).to eq 2
    # end
    #
    # it "remove Document by match" do
    #   collection.create_documents document: [{_key: "ThisIsATest5", test: "fantastic"}, {_key: "ThisIsATest6"}]
    #   result = collection.remove_match match: {test: "fantastic"}
    #   expect(result).to eq 2
    # end
    #
    # it "replace Document by match" do
    #   collection.create_documents document: {test: "fantastic", val: 4}
    #   result = collection.replace_match match: {test: "fantastic"}, newValue: {val: 5}
    #   expect(result).to eq 1
    # end
    #
    # it "update Document by match" do
    #   collection.create_documents document: {test: "fantastic2", val: 5}
    #   result = collection.update_match match: {val: 5}, newValue: {val: 6}
    #   expect(result).to eq 2
    # end

    # it "search random Document" do
    #   info = collection.random
    #   expect(info.collection.name).to eq "DocumentCollection"
    # end
  end

  context "#info" do

    # it "retrieve Edges" do
    #   @edge_collection.create_edges from: ["MyCollection/myA", "MyCollection/myB"],
    #                                  to: @document
    #   myEdges = @document.edges(collection: @edge_collection)
    #   expect(myEdges.length).to eq 2
    # end

    # it "going in different directions" do
    #   document = @document.in("MyEdgeCollection")[0].from.out(@edge_collection)[0].to
    #   expect(document.id).to eq @document.id
    # end
  end

end
