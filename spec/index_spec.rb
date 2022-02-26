require_relative 'spec_helper'

describe Arango::Index do
  before :all do
    @server = connect
    begin
      @server.delete_database(name: "IndexDatabase")
    rescue
    end
    @database = @server.create_database(name: "IndexDatabase")
  end

  before :each do
    begin
      @database.delete_collection(name: "IndexCollection")
    rescue
    end
    @collection = @database.create_collection(name: "IndexCollection")
  end

  after :each do
    begin
      @database.delete_collection(name: "IndexCollection")
    rescue
    end
  end

  after :all do
    @server.delete_database(name: "IndexDatabase")
  end

  context "Index" do
    it "can create a new index" do
      index = Arango::Index.new(collection: @collection, fields: ["checksum"]).create
      expect(index.is_newly_created).to be true
      expect(index.id.class).to be String
    end
    it "can list existing indices" do
      Arango::Index.new(collection: @collection, fields: ["checksum"]).create
      indexes = Arango::Index.list(collection: @collection)
      expect(indexes).not_to be_nil
      expect(indexes.size).to be >= 1
      expect(indexes.map{|i| i.fields}.flatten).to include "checksum"
    end
    it "can retrieve a single index by id" do
      index = Arango::Index.new(collection: @collection, fields: ["checksum"]).create
      result = Arango::Index.get(collection: @collection, id: index.id)
      expect(result.response_code).to eq 200
    end
    it "can delete an index" do
      index = Arango::Index.new(collection: @collection, fields: ["checksum"])
      index.create
      result = index.delete
      expect(result.response_code).to eq 200
    end
    it "handles a duplicate create gracefully" do
      i1 = Arango::Index.new(collection: @collection, fields: ["checksum"]).create
      expect(i1.is_newly_created).to be true
      i2 = Arango::Index.new(collection: @collection, fields: ["checksum"]).create
      expect(i2.is_newly_created).to be false
    end
  end

end
