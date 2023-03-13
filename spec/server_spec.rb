require_relative 'spec_helper'

describe "Arango::Server" do
  before :all do
    @server = connect
  end

  context "Administration" do
    it "available?" do
      expect(@server.available?).to be true
    end

    it "endpoints" do
      expect(@server.endpoints).to be_a Array
    end

    it "cluster_endpoints" do
      if @server.in_cluster?
        expect(@server.cluster_endpoints).to be_a Array
      else
        expect(@server.cluster_endpoints).to be_nil
      end
    end

    it "echo" do
      result = @server.echo(test: 'result')
      expect(Oj.load(result.request_body, mode: :strict)).to eq('test' => 'result')
    end

   if ENV["ARANGODB_BENCHMARK"].nil?
     STDERR.puts "Server benchmark disabled, set ARANGODB_BENCHMARK to enable"
   else
    it 'benchmarking' do
      puts
      Benchmark.ips do |x|
        x.report("echo requests") { @server.echo(test: 'result') }
      end
    end
  end
    it "engine" do
      expect(%w[mmfiles rocksdb]).to include(@server.engine.name)
    end

    it "mmfiles?" do
      expect([true, false]).to include(@server.mmfiles?)
      expect(@server.mmfiles?).not_to be(@server.rocksdb?)
    end

    it "rocksdb?" do
      expect([true, false]).to include(@server.rocksdb?)
      expect(@server.rocksdb?).not_to be(@server.mmfiles?)
    end

    it "log" do
      result = @server.log
      expect(result.total_amount > 1).to be true
    end

    it "log_level" do
      result = @server.log_level
      expect(result.general).to eq('INFO')
    end

    it "log_level=" do
      ll = @server.log_level
      result = @server.log_level=ll
      expect(result.response_code).to eq(200)
    end

    it "mode" do
      expect(@server.mode).to eq(:default)
    end

    it "mode=" do
      expect(@server.mode = :default).to eq(:default)
    end

    it "read_only?" do
      expect(@server.read_only?).to be false
    end

    it "reload_routing" do
      expect(@server.reload_routing).to be true
    end

    it "role" do
      expect(%w[SINGLE COORDINATOR PRIMARY SECONDARY AGENT UNDEFINED]).to include(@server.role)
    end

    it "agent?" do
      expect([true, false]).to include(@server.agent?)
    end

    it "coordinator?" do
      expect([true, false]).to include(@server.coordinator?)
    end

    it "primary?" do
      expect([true, false]).to include(@server.primary?)
    end

    it "secondary?" do
      expect([true, false]).to include(@server.secondary?)
    end

    it "single?" do
      expect([true, false]).to include(@server.single?)
    end

    it "in_cluster?" do
      expect([true, false]).to include(@server.in_cluster?)
    end

    it "server_id" do
      if @server.in_cluster?
        expect(@server.server_id).to be_a(String)
      else
        expect(@server.server_id).to be_nil
      end
    end

    it "statistics" do
      expect(@server.statistics.server[:uptime]).to be_a(Numeric)
    end

    it "statistics_description" do
      expect(@server.statistics_description.groups)
        .to include({ group: "system", name: "Process Statistics", description: "Statistics about the ArangoDB process" })
    end

    it 'status' do
      expect(@server.status.server).to eq('arango')
    end

    it "enterprise?" do
      expect([true, false]).to include(@server.enterprise?)
    end

    it 'time' do
      expect(@server.time).to be_a(Numeric)
    end

    it 'detailed_version' do
      result = @server.detailed_version
      expect(result).to be_a(Arango::Result)
      expect(result.details).to be_a(Hash)
    end

    it 'version' do
      expect(@server.version).to be_a(String)
    end

    it "target_version" do
      expect(@server.target_version).to be_a String
    end

    it "flush_wal" do
      expect(@server.flush_wal).to be true
    end

    it "wal_properties" do
      skip "Response code >= 500"
      result = @server.wal_properties.log_file_size
      expect(result).to eq 14
    end
  end

  context "Config" do
    it "base_uri" do
      uri = @server.base_uri
      expect(uri).to be_a String
      expect(uri.start_with?('http')).to be true
    end

    it "username" do
      expect(@server.username).to eq "root"
    end
  end

  it "transactions" do
    expect(@server.transactions.running_transactions).to be >= 0
  end

  it "transactions_running?" do
    expect([true, false]).to include(@server.transactions_running?)
  end

  # context "#user" do
  #   it "setup an user" do
  #     user = @server.user name: "MyUser2"
  #     expect(user.name).to eq "MyUser2"
  #   end
  # end
  #
  # context "#monitoring" do
  #   # it "clusterStatistics" do
  #   #   expect(@server.clusterStatistics.class).to eq String
  #   # end
  # end
  #
  # context "#lists" do
  #   it "users" do
  #     expect(@server.users[0].class).to be Arango::User
  #   end
  #
  #   it "databases" do
  #     expect(@server.databases[0].class).to be Arango::Database
  #   end
  # end
  #
  # context "#batch" do
  #   it "batch" do
  #     @server.async = false
  #     queries = [{
  #                  method: "POST",
  #                  address: "/_db/MyDatabase/_api/collection",
  #                  body: {name: "newCOLLECTION"},
  #                  id: "1"
  #                },
  #                {
  #                  method: "GET",
  #                  address: "/_api/database",
  #                  id: "2"
  #                }]
  #     val = @server.batch queries: queries
  #     expect(val.class).to be Arango::Batch
  #     response = val.execute
  #     expect(response.class).to be String
  #   end
  #
  #   it "createDumpBatch" do
  #     expect((@server.create_dump_batch ttl: 100).to_i).to be > 1
  #   end
  #
  #   it "prolongDumpBatch" do
  #     dumpBatchID = @server.create_dump_batch ttl: 100
  #     val = @server.prolong_dump_batch ttl: 100, id: dumpBatchID
  #     expect(val).to be true
  #   end
  #
  #   it "destroyDumpBatch" do
  #     dumpBatchID = @server.create_dump_batch ttl: 100
  #     expect(@server.destroy_dump_batch id: dumpBatchID).to be true
  #   end
  # end
  #
  # context "#miscellaneous" do

  # end
end
