module Arango
  module Requests
    module Collection
      class Create < Arango::Request
        request_method :post

        self.uri_template = "/_api/collection"

        param :wait_for_sync_replication
        param :enforce_replication_factor

        body :distribute_shards_like
        body :do_compact
        body :index_buckets
        body :is_system
        body :is_volatile
        body :journal_size
        body :key_options do
          key :allow_user_keys
          key :increment
          key :offset
          key :type
        end
        body :name
        body :number_of_shards
        body :replication_factor
        body :shard_keys
        body :sharding_strategy
        body :smart_join_attribute
        body :type
        body :wait_for_sync
        body :write_concern

        code 200, :success
        code 400, "Collection name is missing!"
        code 404, "Collection name is unknown!"
        code 409, "Collection name is existing!"
      end
    end
  end
end
