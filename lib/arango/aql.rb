module Arango
  #
  # Arango Query Language
  #
  class AQL
    include Arango::Helper::Satisfaction

    class << self

      # @param query_hash [Hash]
      # * id: the query's id
      # * query: the query string (potentially truncated)
      # * bindVars: the bind parameter values used by the query
      # * started: the date and time when the query was started
      # * runTime: the query's run time up to the point the list of queries was queried
      # * state: the query's current execution state (as a string)
      # * stream: whether or not the query uses a streaming cursor
      # @return [Arango::AQL]
      def from_result_hash(query_hash)
        new_query_hash = query_hash.transform_keys { |k| k.to_s.underscore.to_sym }
        new_query_hash[:query_id] = query_hash.delete(:id)
        Arango::AQL.new(**new_query_hash)
      end
    end

    # Create a new AQL query
    # @param query
    # @param database
    # @param batch_size
    # @param bind_vars
    # @param cache
    # @param count
    # @param fail_on_warning
    # @param full_count
    # @param intermediate_commit_count
    # @param intermediate_commit_size
    # @param max_plans
    # @param max_transaction_size
    # @param max_warning_count
    # @param memory_limit
    # @param optimizer_rules
    # @param profile
    # @param satellite_sync_wait
    # @param skip_inaccessible_collections
    # @param ttl
    # @param query_id
    # @param run_time
    # @param started
    # @param state
    # @param stream
    # @param block
    # @param &ruby_block
    def initialize(query:, database:, batch_size: nil, bind_vars: nil, cache: nil, count: nil, fail_on_warning: nil, full_count: nil,
                   intermediate_commit_count: nil, intermediate_commit_size: nil, max_plans: nil, max_transaction_size: nil,
                   max_warning_count: nil, memory_limit: nil, optimizer_rules: nil, profile: nil, satellite_sync_wait: nil,
                   skip_inaccessible_collections: nil, ttl: nil,
                   query_id: nil, run_time: nil, started: nil, state: nil, stream: nil,
                   block: nil, &ruby_block)
      block = ruby_block if block_given?
      satisfy_class?(query, String)
      @query = query
      @database = database
      @server = database.server

      @block        = block

      @count        = count
      @batch_size   = batch_size
      @cache        = cache
      @memory_limit = memory_limit
      @ttl          = ttl
      @bind_vars    = bind_vars

      @has_more = false
      @id       = nil # cursor id
      @query_id = query_id
      @result   = nil

      @run_time = run_time
      @started = started
      @state = state
      @stream = stream

      @options  = {}
      set_option(fail_on_warning, 'failOnWarning', :fail_on_warning) if fail_on_warning
      set_option(full_count, 'fullCount', :full_count) if full_count
      set_option(intermediate_commit_count, 'intermediateCommitCount', :intermediate_commit_count) if intermediate_commit_count
      set_option(intermediate_commit_size, 'intermediateCommitSize', :intermediate_commit_size) if intermediate_commit_size
      set_option(max_plans, 'maxPlans', :max_plans) if max_plans
      set_option(max_transaction_size, 'maxTransactionSize', :max_transaction_size) if max_transaction_size
      set_option(max_warning_count, 'maxWarningCount', :max_warning_count) if max_warning_count
      set_option(profile, 'profile', :profile) if profile
      set_option(satellite_sync_wait, 'satelliteSyncWait', :satellite_sync_wait) if satellite_sync_wait
      set_option(skip_inaccessible_collections, 'skipInaccessibleCollections', :skip_inaccessible_collections) if skip_inaccessible_collections
      send(:optimizer_rules=, optimizer_rules) if optimizer_rules
    end

    # set optimizer rules
    # @param attrs [Hash]
    def optimizer_rules=(attrs)
      @optimizer_rules = attrs
      if attrs.nil?
        @options.delete('optimizer.rules')
      else
        @options['optimizer.rules'] = attrs
      end
    end

    # @!attribute [r] failOnWarning
    #   @return [Boolean] fail on warning
    # @!attribute [r] fullCount
    #   @return [Integer] full count
    # @!attribute [r] intermediateCommitCount
    #   @return [Integer] intermediate commit count
    # @!attribute [r] intermediateCommitSize
    #   @return [Integer] intermediate commit size
    # @!attribute [r] maxPlans
    #   @return [Integer] max plans
    # @!attribute [r] maxTransactionSize
    #   @return [Integer] max transaction size
    # @!attribute [r] maxWarningCount
    #   @return [Integer] max warning count
    # @!attribute [r] profile
    #   @return [Hash] profile
    # @!attribute [r] satelliteSyncWait
    #   @return [Boolean] satellite sync wait
    # @!attribute [r] skipInaccessibleCollections
    #   @return [Boolean] skip inaccessible collections 
    %w[failOnWarning fullCount intermediateCommitCount intermediateCommitSize maxPlans maxTransactionSize maxWarningCount
     profile satelliteSyncWait skipInaccessibleCollections].each do |param_name|
      var_name = param_name.underscore.to_sym
      attr_reader var_name
      define_method("#{var_name}=") do |value|
        set_option(value, param_name, var_name)
      end
    end

    attr_accessor :batch_size, :bind_vars, :cache, :count, :options, :query, :ttl

    attr_reader :server, :cached, :database, :extra, :id, :id_cache, :optimizer_rules, :result
    attr_reader :run_time, :started, :state, :stream

    # check if more results are pending
    # @return [Boolean]
    def has_more?
      @has_more
    end

    # return Hash representation
    # @return [Hash]
    def to_h
      {
        batchSize:   @batch_size,
        bindVars:    @bind_vars,
        cache:       @cache,
        count:       @count,
        database:    @database.name,
        idCache:     @id_cache,
        memoryLimit: @memory_limit,
        options:     @options,
        query:       @query,
        result:      @result,
        ttl:         @ttl
      }.delete_if{|_,v| v.nil?}
    end

    # run an AQL request
    # @param &block
    # @return [Arango::AQL] (if no block passed)
    def request
      body = {
          batchSize:   @batch_size,
          cache:       @cache,
          count:       @count,
          memoryLimit: @memory_limit,
          options:     @options,
          query:       @query,
          ttl:         @ttl
        }
      body[:bindVars] = @bind_vars if @bind_vars

      result = Arango::Requests::Cursor::Create.execute(server: @server, body: body)
      set_instance_vars(result)
      @block ? @block.call(self, result) : self
    end

    # see {request}
    def execute
      request
    end

    # get next result of query
    # @return [Arango::AQL]
    def next
      if @has_more
        result = Arango::Requests::Cursor::NextBatch.execute(server: @server, args: { id: @id })
        set_instance_vars(result)
        self
      else
        raise Arango::Error.new err: :no_other_aql_next, data: { has_more: false }
      end
    end

    # delete current query
    def delete
      Arango::Requests::Cursor::Delete.execute(server: @server, args: { id: @id })
      true
    end

    # kill current query
    def kill
      Arango::Requests::AQL::KillQuery.execute(server: @server, args: { id: @query_id })
      true
    end

# === PROPERTY QUERY ===

    # explain current query
    def explain
      body = {
        query:    @query,
        options:  @options
      }
      body[:bindVars] = @bind_vars if @bind_vars
      Arango::Requests::AQL::Explain.execute(server: @server, body: body)
    end

    # parse current query
    def parse
      Arango::Requests::AQL::Parse.execute(server: @server, body: { query: @query })
    end

    private

    def set_option(attrs, name, var_name)
      instance_variable_set("@#{var_name}", attrs)
      if attrs.nil?
        @options.delete(name)
      else
        @options[name] = attrs
      end
    end

    def set_instance_vars(result)
      @cached   = result[:cached]
      @extra    = result[:extra]
      @has_more = result[:has_more]
      @id       = result[:id]
      @count    = result[:count]
      @result   = result[:result]
    end
  end
end
