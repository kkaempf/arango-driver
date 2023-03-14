module Arango
  # Arango Requests
  module Requests
    # Cursor Requests
    module Cursor
      # API: POST /_api/cursor
      class Create < Arango::Request
        self.request_method = :post

        self.uri_template = "/_api/cursor"

        body :batch_size
        body :bind_vars
        body :cache
        body :count
        body :memory_limit
        body :options do
          key :fail_on_warning
          key :full_count
          key :intermediate_commit_count
          key :intermediate_commit_size
          key :max_plans
          key :max_runtime
          key :max_transaction_size
          key :max_warning_count
          key :optimizer
          key :profile
          key :satellite_sync_wait
          key :skip_inaccessible_collection
          key :stream
        end
        body :query
        body :ttl

        code 201, :success
        code 400, "The JSON representation is malformed or the query specification is missing from the request!"
        code 404, "Collection is unknown!"
        code 405, "Unsupported HTTP method used."
      end
    end
  end
end
