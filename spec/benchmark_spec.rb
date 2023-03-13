require_relative 'spec_helper'
require 'benchmark'

NUMBER_OF_RUNS = 5000

if ENV["ARANGODB_BENCHMARK"].nil?
  STDERR.puts "benchmark_spec disabled, set ARANGODB_BENCHMARK to enable"
else
describe Arango::Server do
  context "benchmark http" do
    before :all do
      @server = connect
      begin
        @server.delete_database(name: "BenchmarkDatabase")
      rescue
      end
      @database = @server.create_database(name: "BenchmarkDatabase")
      @collection = @database.create_collection name: "MyCollection"
    end

    after :all do
      begin
        @database.delete_collection(name: 'MyCollection')
      rescue
      end
      @server.delete_database(name: "BenchmarkDatabase")
    end

    it "version works" do
      expect(@server.version).to be_a String
      puts
    end

    it "doc benchmark in kops" do
      result = nil
      elapsed = Benchmark.realtime do
        # n sets, n get
        NUMBER_OF_RUNS.times do |i|
          key = "foo#{i}"
          @collection.create_document(attributes: {key: key, value: key * 10})
          result = @collection.get_document(key: key).value
        end
      end
      NUMBER_OF_RUNS.times do |i|
        key = "foo#{i}"
        @collection.delete_document(key: key)
      end
      puts 'Write/Read: %.2f Kops' % (2 * NUMBER_OF_RUNS / 1000 / elapsed)
      expect(result).to be_a String
    end

    it "doc write benchmark in kops" do
      elapsed = Benchmark.realtime do
        # n sets, n get
        NUMBER_OF_RUNS.times do |i|
          key = "foo#{i}"
          @collection.create_document(attributes: {key: key, value: key * 10})
        end
      end
      NUMBER_OF_RUNS.times do |i|
        key = "foo#{i}"
        @collection.delete_document(key: key)
      end
      puts 'Write: %.2f Kops' % (NUMBER_OF_RUNS / 1000 / elapsed)
    end

    it "doc read benchmark in kops" do
      result = nil
      NUMBER_OF_RUNS.times do |i|
        key = "foo#{i}"
        @collection.create_document(attributes: {key: key, value: key * 10})
      end
      elapsed = Benchmark.realtime do
        # n sets, n get
        NUMBER_OF_RUNS.times do |i|
          key = "foo#{i}"
          result = @collection.get_document(key: key).value
        end
      end
      NUMBER_OF_RUNS.times do |i|
        key = "foo#{i}"
        @collection.delete_document(key: key)
      end
      puts 'Read: %.2f Kops' % (NUMBER_OF_RUNS / 1000 / elapsed)
      expect(result).to be_a String
    end

    it "version benchmark in kops" do
      result = nil
      elapsed = Benchmark.realtime do
        # n sets, n get
        NUMBER_OF_RUNS.times do |i|
          result = @server.version
        end
      end
      puts 'version: %.2f Kops' % (NUMBER_OF_RUNS / 1000 / elapsed)
      expect(result).to be_a String
    end

    it "AQL  in kops" do
      NUMBER_OF_RUNS.times do |i|
        key = "foo#{i}"
        @collection.create_document(attributes: {key: key, value: key * 10})
      end
      result = nil
      elapsed = Benchmark.realtime do
        # n sets, n get
        NUMBER_OF_RUNS.times do |i|
          result = @database.execute_query('FOR d IN MyCollection FILTER d._key == @key RETURN d', bind_vars: {key: "foo#{i}"})
        end
      end
      NUMBER_OF_RUNS.times do |i|
        key = "foo#{i}"
        @collection.delete_document(key: key)
      end
      puts 'AQL queries: %.2f Kops' % (NUMBER_OF_RUNS / 1000 / elapsed)
      expect(result.result.first).to be_a Hash
    end

#    it "Javascript AQL function in kops" do
#      @server.install_opal_module(@database)
#      @database.create_aql_function('JASC::DOCMOD', code: <<~JAVASCRIPT
#        function(doc) {
#          "use strict";
#          doc.value = doc.value + '_ruby_rocks';
#          return doc;
#        }
#      JAVASCRIPT
#      )
#      NUMBER_OF_RUNS.times do |i|
#        key = "foo#{i}"
#        @collection.create_document(attributes: {key: key, value: key * 10})
#      end
#      result = nil
#      elapsed = Benchmark.realtime do
#        # n sets, n get
#        NUMBER_OF_RUNS.times do |i|
#          result = @database.execute_query('FOR d IN MyCollection FILTER d._key == @key RETURN JASC::DOCMOD(d)', bind_vars: {key: "foo#{i}"})
#       end
#      end
#      NUMBER_OF_RUNS.times do |i|
#        key = "foo#{i}"
#        @collection.delete_document(key: key)
#      end
#      puts 'Javascript AQL function: %.2f Kops' % (NUMBER_OF_RUNS / 1000 / elapsed)
#      expect(result.result.first).to be_a Hash
#    end

#    it "Ruby AQL function in kops" do
#      @server.install_opal_module(@database)
#      @database.create_aql_function('RUBY::DOCMOD') do
#        doc = args[0]
#        doc[:value] = doc[:value] + '_ruby_rocks'
#        doc
#      end
#      NUMBER_OF_RUNS.times do |i|
#        key = "foo#{i}"
#        @collection.create_document(attributes: {key: key, value: key * 10})
#      end
#      result = nil
#      elapsed = Benchmark.realtime do
#        # n sets, n get
#        NUMBER_OF_RUNS.times do |i|
#          result = @database.execute_query('FOR d IN MyCollection FILTER d._key == @key RETURN RUBY::DOCMOD(d)', bind_vars: {key: "foo#{i}"})
#        end
#      end
#      NUMBER_OF_RUNS.times do |i|
#        key = "foo#{i}"
#        @collection.delete_document(key: key)
#      end
#      puts 'Ruby AQL function: %.2f Kops' % (NUMBER_OF_RUNS / 1000 / elapsed)
#      expect(result.result.first).to be_a Hash
#    end
  end
end
end # if ARANGODB_BENCHMARK