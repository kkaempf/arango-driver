require_relative 'spec_helper'

describe Arango::Database do
  before :all do
    @server = connect
  end

  before :each do
    begin
      @server.delete_database(name: "MyDatabase")
    rescue
    end
  end

  after :each do
    begin
      @server.delete_database(name: "MyDatabase")
    rescue
    end
  end

  context "Server" do
    it "new_database" do
      database = @server.new_database name: "MyDatabase"
      expect(database.name).to eq "MyDatabase"
    end

    it "create_database" do
      database = @server.create_database name: "MyDatabase"
      expect(database.name).to eq "MyDatabase"
    end

    it "fails to create a duplicate Database" do
      @server.create_database name: "MyDatabase"
      error = nil
      begin
        @server.create_database name: "MyDatabase"
      rescue Arango::Error => e
        error = e.message
      end
      expect(error).to include "duplicate database"
    end

    it "list_databases" do
      @server.create_database name: "MyDatabase"
      list = @server.list_databases
      expect(list).to include("MyDatabase")
    end

    it "list_user_databases" do
      @server.create_database name: "MyDatabase"
      list = @server.list_user_databases
      expect(list).to include("MyDatabase")
    end

    it "delete_database" do
      @server.create_database name: "MyDatabase"
      list = @server.list_databases
      expect(list).to include("MyDatabase")
      @server.delete_database(name: "MyDatabase")
      list = @server.list_databases
      expect(list).not_to include("MyDatabase")
    end

    it "database_exists?" do
      expect(@server.database_exists?(name: "MyDatabase")).to be false
      @server.create_database name: "MyDatabase"
      expect(@server.database_exists?(name: "MyDatabase")).to be true
    end

    it "all_databases" do
      @server.create_database name: "MyDatabase"
      alldb = @server.all_databases
      expect(alldb.map(&:name)).to include("MyDatabase")
    end

    it "all_user_databases" do
      @server.create_database name: "MyDatabase"
      alldb = @server.all_user_databases
      expect(alldb.map(&:name)).to include("MyDatabase")
    end

    it "get_database" do
      @server.create_database name: "MyDatabase"
      database = @server.get_database(name: "MyDatabase")
      expect(database.name).to eq "MyDatabase"
    end
  end

  context "Arango::Database itself" do
    it "target_version" do
      database = @server.create_database name: "MyDatabase"
      expect(database.target_version).to be_a String
    end
  end

  # context "#info" do
  #   it "obtain general info" do
  #     @database.retrieve
  #     expect(@database.name).to eq "MyDatabase"
  #   end
  # end

  # context "#query" do
  #   it "properties" do
  #     expect(@database.query_properties[:enabled]).to be true
  #   end
  #
  #   it "current" do
  #     expect(@database.current_query.empty?).to be true
  #   end
  #
  #   it "slow" do
  #     expect(@database.slow_queries.empty?).to be true
  #   end
  # end

  # context "#delete query" do
  #   it "stopSlow" do
  #     expect(@database.stop_slow_queries).to be true
  #   end
  #
  #   # it "kill" do
  #   #   @myCollection.create
  #   #   @myCollection.createDocuments document: [{num: 1, _key: "FirstKey"},
  #   #     {num: 1}, {num: 1}, {num: 1}, {num: 1}, {num: 1},
  #   #     {num: 1}, {num: 2}, {num: 2}, {num: 2}, {num: 3},
  #   #     {num: 2}, {num: 5}, {num: 2}]
  #   #   myAQL = @database.aql query: 'FOR i IN 1..1000000
  #   # INSERT { name: CONCAT("test", i) } IN MyCollection'
  #   #   myAQL.size = 3
  #   #   myAQL.execute
  #   #   error = ""
  #   #   begin
  #   #     @database.killAql query: myAQL
  #   #   rescue Arango::Error => e
  #   #     error = e.message
  #   #   end
  #   #   expect(error.include?("It could have already been killed")).to eq true
  #   # end
  #
  #   it "changeProperties" do
  #     result = @database.change_query_properties max_slow_queries: 65
  #     expect(result[:maxSlowQueries]).to eq 65
  #   end
  # end

  # context "#cache" do
  #   it "clear" do
  #     expect(@database.clear_query_cache).to be true
  #   end
  #
  #   it "change Property Cache" do
  #     @database.change_query_properties max_slow_queries: 130
  #     expect(@database.query_properties[:maxSlowQueries]).to eq 130
  #   end
  # end

  # context "#function" do
  #   it "create Function" do
  #     result = @database.create_aql_function name: "myfunctions::temperature::celsiustofahrenheit",
  #     code: "function (celsius) { return celsius * 1.8 + 32; }"
  #     expect(result.class).to eq Hash
  #   end
  #
  #   it "list Functions" do
  #     result = @database.aql_functions
  #     expect(result[0][:name]).to eq "myfunctions::temperature::celsiustofahrenheit"
  #   end
  #
  #   it "delete Function" do
  #     result = @database.delete_aql_function name: "myfunctions::temperature::celsiustofahrenheit"
  #     expect(result).to be true
  #   end
  # end


  # context "#user" do
  #   it "grant" do
  #     expect(@database.add_user_access(grant: "ro", user: @myUser)).to eq "ro"
  #   end
  #
  #   it "revoke" do
  #     expect(@database.revoke_user_access user: @myUser).to be true
  #   end
  # end
end
