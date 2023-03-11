module Arango
  #
  # Arango Transaction
  #
  class Transaction
    include Arango::Helper::Satisfaction

    include Arango::Helper::DatabaseAssignment

    def initialize(action:, database:, intermediate_commit_size: nil, intermediate_commit_count: nil, lock_timeout: nil, max_transaction_size: nil,
                   params: nil, read: [], wait_for_sync: nil, write: [])
      assign_database(database)
      @action = action
      @intermediate_commit_count = intermediate_commit_count
      @intermediate_commit_size   = intermediate_commit_size
      @lock_timeout             = lock_timeout
      @max_transaction_size      = max_transaction_size
      @params = params
      @read   = return_write_or_read(read)
      @result = nil
      @wait_for_sync             = wait_for_sync
      @write  = return_write_or_read(write)
    end

# === DEFINE ===

    attr_reader :database, :read, :result, :server, :write
    attr_accessor :action, :intermediate_commit_count, :intermediate_commit_size, :lock_timeout, :max_transaction_size, :params, :wait_for_sync

    def write=(write)
      @write = return_write_or_read(write)
    end

    def add_write(write)
      write = return_write_or_read(write)
      @write ||= []
      @write << write
    end

    def read=(read)
      @read = return_write_or_read(read)
    end

    def add_read(read)
      read = return_write_or_read(read)
      @read ||= []
      @read << read
    end

    def return_write_or_read(value)
      case value
      when Array
        return value.map{|x| return_collection(x)}
      when String, Arango::DocumentCollection
        return [return_collection(value)]
      when NilClass
        return []
      else
        raise Arango::Error.new err: :read_or_write_should_be_string_or_collections, data: {wrong_value: value, wrong_class: value.class}
      end
    end
    private :return_write_or_read

    def return_collection(collection, type=nil)
      case collection
      when Arango::DocumentCollection::Mixin then return collection
      when String then return Arango::DocumentCollection.new(name: collection, database: @database)
      else raise "wrong type"
      end
    end
    private :return_collection

# === TO HASH ===

    def to_h
      {
        action: @action,
        database: @database.name,
        params: @params,
        read: @read.map{|x| x.name},
        result: @result,
        write: @write.map{|x| x.name}
      }.delete_if{|k,v| v.nil?}
    end

# === EXECUTE ===

    def execute(action: @action, params: @params,
      max_transaction_size: @max_transaction_size,
      lock_timeout: @lock_timeout, wait_for_sync: @wait_for_sync,
      intermediate_commit_count: @intermediate_commit_count,
      intermediate_commit_size: @intermediate_commit_size)
      body = {
        collections: {
          read: @read.map{|x| x.name},
          write: @write.map{|x| x.name}
        },
        action: action,
        intermediate_commit_size: intermediate_commit_size,
        intermediateCommitCount: intermediate_commit_count,
        lockTimeout: lock_timeout,
        maxTransactionSize: max_transaction_size,
        params: params,
        waitForSync: wait_for_sync
      }
      result = @database.request("POST", "_api/transaction", body: body)
      return result if @server.async != false
      @result = result[:result]
      return return_directly?(result) ? result : result[:result]
    end
  end
end
