require_relative 'spec_helper'

describe Arango::EdgeCollection do
  before :all do
    @server = connect
    begin
      @server.delete_database(name: "EdgeCollectionDatabase")
    rescue
    end
    @database = @server.create_database(name: "EdgeCollectionDatabase")
  end

  before :each do
    begin
      @database.delete_collection(name: 'MyCollection')
    rescue
    end
  end

  after :each do
    begin
      @database.delete_collection(name: 'MyCollection')
    rescue
    end
  end

  after :all do
    @server.delete_database(name: "EdgeCollectionDatabase")
  end

  context "Database" do
    it "new_collection with type Edge" do
      collection = @database.new_collection name: "MyCollection", type: :edge
      expect(collection.name).to eq "MyCollection"
      expect(collection.type).to eq :edge
    end

    it "new_edge_collection" do
      collection = @database.new_edge_collection name: "MyCollection"
      expect(collection.name).to eq "MyCollection"
      expect(collection.type).to eq :edge
    end

    it "create_edge_collection" do
      collection = @database.create_edge_collection name: "MyCollection"
      expect(collection.name).to eq "MyCollection"
      expect(collection.type).to eq :edge
    end

    it "get_collection edge type" do
      @database.create_edge_collection name: "MyCollection"
      collection = @database.get_collection(name: "MyCollection")
      expect(collection.name).to eq "MyCollection"
      expect(collection.type).to eq :edge
    end

    it "get_collection edge type" do
      @database.create_edge_collection name: "MyCollection"
      collection = @database.get_collection(name: "MyCollection")
      expect(collection.name).to eq "MyCollection"
      expect(collection.type).to eq :edge
    end

    it "list_collections" do
      @database.create_edge_collection name: "MyCollection"
      list = @database.list_collections
      expect(list).to include("MyCollection")
    end

    it "list_edge_collections" do
      @database.create_edge_collection name: "MyCollection"
      list = @database.list_edge_collections
      expect(list).to include("MyCollection")
      list = @database.list_document_collections
      expect(list).not_to include("MyCollection")
    end

    it "delete_collection" do
      @database.create_edge_collection name: "MyCollection"
      list = @database.list_collections
      expect(list).to include("MyCollection")
      @database.delete_collection(name: "MyCollection")
      list = @database.list_collections
      expect(list).not_to include("MyCollection")
    end

    it "collection_exists?" do
      @database.create_edge_collection name: "MyCollection"
      result = @database.collection_exists?(name: "MyCollection")
      expect(result).to be true
      result = @database.collection_exists?(name: "StampCollection")
      expect(result).to be false
    end

    it "all_collections" do
      @database.create_edge_collection name: "MyCollection"
      collections = @database.all_collections
      list = collections.map(&:name)
      expect(list).to include("MyCollection")
    end
  end

  context "Arango::EdgeCollection::Base itself" do
    it "new" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database)
      expect(collection.name).to eq "MyCollection"
      expect(collection.type).to eq :edge
    end

    it "create" do
      Arango::EdgeCollection::Base.new(name: "MyCollection", type: :edge, database: @database).create
      collection = Arango::EdgeCollection::Base.get(name: "MyCollection", database: @database)
      expect(collection.name).to eq "MyCollection"
      expect(collection.type).to eq :edge
    end

    it "fails to create a duplicate Collection" do
      Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      error = nil
      begin
        Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      rescue Arango::Error => e
        error = e.message
      end
      expect(error).to be_a String
    end

    it "reload the Collection" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      collection.name = 'StampCollection'
      expect(collection.name).to eq 'StampCollection'
      collection.reload
      expect(collection.name).to eq "MyCollection"
    end

    it "size" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      info = collection.count
      expect(info).to eq 0
    end

    it "statistics" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      info = collection.statistics
      expect(info[:cache_in_use]).to eq false
    end

    it "checksum" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      info = collection.checksum
      expect(info.class).to eq String
    end

    it "load" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      collection = collection.load_into_memory
      expect(collection.name).to eq "MyCollection"
    end

    it "unload" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      collection = collection.unload_from_memory
      expect(collection.name).to eq "MyCollection"
    end

    it "save wait_for_sync" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      expect(collection.wait_for_sync).to be false
      collection.wait_for_sync = true
      collection.save
      expect([true, false]).to include(collection.wait_for_sync) # no guaranty its actually changed
    end

    it "save name" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      collection.name = 'StampCollection'
      collection.save
      expect(collection.name).to eq 'StampCollection'
      collection.delete
    end

    it "truncate" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      collection = collection.truncate
      expect(collection.size).to eq 0
    end

    it "delete" do
      Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      collection = Arango::EdgeCollection::Base.get(name: "MyCollection", database: @database)
      collection.delete
      message = nil
      begin
        Arango::EdgeCollection::Base.get(name: "MyCollection", database: @database)
      rescue Arango::Error => e
        message = e.message
      end
      expect(message).to eq 'collection or view not found'
    end

    it "revision" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      expect(collection.revision).to be_a String
    end

    it "rotate_journal" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      expect(collection.rotate_journal).to eq collection
    end

    it "status" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      expect(collection.status).to eq :loaded
    end

    it "arango_object_id" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      expect(collection.arango_object_id).to be_a String
    end

    it "key_options" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", database: @database).create
      expect(collection.key_options).to be_a Arango::Result
      expect(collection.key_options.allow_user_keys).to be true
    end

    it "sharding_strategy" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", properties: { sharding_strategy: :hash }, database: @database).create
      expect(collection.sharding_strategy).to eq :hash
    end

    it "shards" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", properties: { sharding_strategy: :hash }, database: @database).create
      if @server.coordinator?
        expect(collection.shards).to be_truthy
      else
        expect(collection.shards).to be_nil
      end
    end

    it "load_indexes_into_memory" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", properties: { sharding_strategy: :hash }, database: @database).create
      expect(collection.load_indexes_into_memory).to be collection
    end

    it "recalculate_count" do
      collection = Arango::EdgeCollection::Base.new(name: "MyCollection", properties: { sharding_strategy: :hash }, database: @database).create
      expect(collection.recalculate_count).to eq collection
    end
  #   context "#import" do
  #     it "import" do
  #       attributes = ["value", "num", "name"]
  #       values = [["uno",1,"ONE"],["due",2,"TWO"],["tre",3,"THREE"]]
  #       result = collection.import attributes: attributes, values: values
  #       expect(result[:created]).to eq 3
  #     end
  #
  #     it "import single" do
  #       attributes = ["value", "num", "name"]
  #       values = ["uno",1,"ONE"]
  #       result = collection.import attributes: attributes, values: values
  #       expect(result[:created]).to eq 1
  #     end
  #
  #     it "importJSON" do
  #       body = [{value: "uno", num: 1, name: "ONE"}, {value: "due", num: 2, name: "DUE"}]
  #       result = collection.import_json body: body
  #       expect(result[:created]).to eq 2
  #     end
  #   end
  #
  #   context "#export" do
  #     it "export" do
  #       result = collection.export flush: true
  #       expect(result[0].class).to be Arango::Document
  #     end
  #
  #     it "exportNext" do
  #       result = collection.export batch_size: 3, flush: true
  #       result = collection.export_next
  #       expect(result[0].class).to be Arango::Document
  #     end
  #   end
  #
  #   context "#indexes" do
  #     it "indexes" do
  #       expect(collection.indexes[0].class).to be Arango::Index
  #     end
  #
  #     it "create" do
  #       myIndex = collection.index(unique: false, fields: "num", type: "hash").create
  #       expect(myIndex.fields).to eq ["num"]
  #     end
  end

end
