module Arango
  # Arango Database
  class Database
    # Arango Database AQLQueries
    module AQLQueries
      def new_aql(query:, batch_size: nil, bind_vars: nil, cache: nil, count: nil, fail_on_warning: nil, full_count: nil,
                  intermediate_commit_count: nil, intermediate_commit_size: nil, max_plans: nil, max_transaction_size: nil,
                  max_warning_count: nil, memory_limit: nil, optimizer_rules: nil, profile: nil, satellite_sync_wait: nil,
                  skip_inaccessible_collections: nil, ttl: nil, block: nil, &ruby_block)
        Arango::AQL.new(database: self, query: query, batch_size: batch_size, bind_vars: bind_vars, cache: cache, count: count,
                        fail_on_warning: fail_on_warning, full_count: full_count, intermediate_commit_count: intermediate_commit_count,
                        intermediate_commit_size: intermediate_commit_size, max_plans: max_plans, max_transaction_size: max_transaction_size,
                        max_warning_count: max_warning_count, memory_limit: memory_limit, optimizer_rules: optimizer_rules, profile: profile,
                        satellite_sync_wait: satellite_sync_wait, skip_inaccessible_collections: skip_inaccessible_collections, ttl: ttl,
                        block: block, &ruby_block)
      end

      def new_query(query, batch_size: nil, bind_vars: nil, cache: nil, count: nil, fail_on_warning: nil, full_count: nil,
                    intermediate_commit_count: nil, intermediate_commit_size: nil, max_plans: nil, max_transaction_size: nil,
                    max_warning_count: nil, memory_limit: nil, optimizer_rules: nil, profile: nil, satellite_sync_wait: nil,
                    skip_inaccessible_collections: nil, ttl: nil, block: nil, &ruby_block)
        Arango::AQL.new(database: self, query: query, batch_size: batch_size, bind_vars: bind_vars, cache: cache, count: count,
                        fail_on_warning: fail_on_warning, full_count: full_count, intermediate_commit_count: intermediate_commit_count,
                        intermediate_commit_size: intermediate_commit_size, max_plans: max_plans, max_transaction_size: max_transaction_size,
                        max_warning_count: max_warning_count, memory_limit: memory_limit, optimizer_rules: optimizer_rules, profile: profile,
                        satellite_sync_wait: satellite_sync_wait, skip_inaccessible_collections: skip_inaccessible_collections, ttl: ttl,
                        block: block, &ruby_block)
      end

      def execute_aql(query:, batch_size: nil, bind_vars: nil, cache: nil, count: nil, fail_on_warning: nil, full_count: nil,
                      intermediate_commit_count: nil, intermediate_commit_size: nil, max_plans: nil, max_transaction_size: nil,
                      max_warning_count: nil, memory_limit: nil, optimizer_rules: nil, profile: nil, satellite_sync_wait: nil,
                      skip_inaccessible_collections: nil, ttl: nil, block: nil, &ruby_block)
        aql = Arango::AQL.new(database: self, query: query, batch_size: batch_size, bind_vars: bind_vars, cache: cache, count: count,
                              fail_on_warning: fail_on_warning, full_count: full_count, intermediate_commit_count: intermediate_commit_count,
                              intermediate_commit_size: intermediate_commit_size, max_plans: max_plans, max_transaction_size: max_transaction_size,
                              max_warning_count: max_warning_count, memory_limit: memory_limit, optimizer_rules: optimizer_rules, profile: profile,
                              satellite_sync_wait: satellite_sync_wait, skip_inaccessible_collections: skip_inaccessible_collections, ttl: ttl,
                              block: block, &ruby_block)
        aql.execute
      end

      def execute_query(query, batch_size: nil, bind_vars: nil, cache: nil, count: nil, fail_on_warning: nil, full_count: nil,
                        intermediate_commit_count: nil, intermediate_commit_size: nil, max_plans: nil, max_transaction_size: nil,
                        max_warning_count: nil, memory_limit: nil, optimizer_rules: nil, profile: nil, satellite_sync_wait: nil,
                        skip_inaccessible_collections: nil, ttl: nil, block: nil, &ruby_block)
        aql = Arango::AQL.new(database: self, query: query, batch_size: batch_size, bind_vars: bind_vars, cache: cache, count: count,
                              fail_on_warning: fail_on_warning, full_count: full_count, intermediate_commit_count: intermediate_commit_count,
                              intermediate_commit_size: intermediate_commit_size, max_plans: max_plans, max_transaction_size: max_transaction_size,
                              max_warning_count: max_warning_count, memory_limit: memory_limit, optimizer_rules: optimizer_rules, profile: profile,
                              satellite_sync_wait: satellite_sync_wait, skip_inaccessible_collections: skip_inaccessible_collections, ttl: ttl,
                              block: block, &ruby_block)
        aql.execute
      end

      def batch_execute_aql(query:, batch_size: nil, bind_vars: nil, cache: nil, count: nil, fail_on_warning: nil, full_count: nil,
                            intermediate_commit_count: nil, intermediate_commit_size: nil, max_plans: nil, max_transaction_size: nil,
                            max_warning_count: nil, memory_limit: nil, optimizer_rules: nil, profile: nil, satellite_sync_wait: nil,
                            skip_inaccessible_collections: nil, ttl: nil, block: nil, &ruby_block)
        aql = Arango::AQL.new(database: self, query: query, batch_size: batch_size, bind_vars: bind_vars, cache: cache, count: count,
                              fail_on_warning: fail_on_warning, full_count: full_count, intermediate_commit_count: intermediate_commit_count,
                              intermediate_commit_size: intermediate_commit_size, max_plans: max_plans, max_transaction_size: max_transaction_size,
                              max_warning_count: max_warning_count, memory_limit: memory_limit, optimizer_rules: optimizer_rules, profile: profile,
                              satellite_sync_wait: satellite_sync_wait, skip_inaccessible_collections: skip_inaccessible_collections, ttl: ttl,
                              block: block, &ruby_block)
        aql.batch_execute
      end

      def batch_execute_query(query, batch_size: nil, bind_vars: nil, cache: nil, count: nil, fail_on_warning: nil, full_count: nil,
                            intermediate_commit_count: nil, intermediate_commit_size: nil, max_plans: nil, max_transaction_size: nil,
                            max_warning_count: nil, memory_limit: nil, optimizer_rules: nil, profile: nil, satellite_sync_wait: nil,
                            skip_inaccessible_collections: nil, ttl: nil, block: nil, &ruby_block)
        aql = Arango::AQL.new(database: self, query: query, batch_size: batch_size, bind_vars: bind_vars, cache: cache, count: count,
                              fail_on_warning: fail_on_warning, full_count: full_count, intermediate_commit_count: intermediate_commit_count,
                              intermediate_commit_size: intermediate_commit_size, max_plans: max_plans, max_transaction_size: max_transaction_size,
                              max_warning_count: max_warning_count, memory_limit: memory_limit, optimizer_rules: optimizer_rules, profile: profile,
                              satellite_sync_wait: satellite_sync_wait, skip_inaccessible_collections: skip_inaccessible_collections, ttl: ttl,
                              block: block, &ruby_block)
        aql.batch_execute
      end

      def query_tracking_properties
        Arango::Requests::AQL::GetQueryTrackingProperties.execute(server: @server)
      end

      def set_query_tracking_properties(props)
        body = props.to_h
        body.transform_keys! { |k| k.to_s.camelize(:lower).to_sym }
        Arango::Requests::AQL::SetQueryTrackingProperties.execute(server: @server, body: props.to_h)
      end

      def running_queries
        result = Arango::Requests::AQL::CurrentQueries.execute(server: @server)
        result.map { |query_hash| Arango::AQL.from_result(query_hash) }
      end

      def slow_queries
        result = Arango::Requests::AQL::GetSlowQueryList.execute(server: @server)
        result.map { |query_hash| Arango::AQL.from_result(query_hash) }
      end

      def clear_slow_queries_list
        result = Arango::Requests::AQL::DeleteSlowQueryList.execute(server: @server)
        true
      end

      def kill_query(aql_id)
        id = if id.class == String then id
             elsif id.class == Arango::AQL then id.id
             end
        result = Arango::Requests::AQL::KillQuery.execute(server: @server, args: {id: id})
        true
      end
    end
  end
end
