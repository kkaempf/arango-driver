module Arango
  module Requests
    module Replication
      class SetApplierConfig < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/replication/applier-config'

        body :adaptive_polling
        body :auto_resync
        body :auto_resync_retries
        body :auto_start
        body :chunk_size
        body :connect_timeout
        body :connection_retry_wait_time
        body :database
        body :endpoint
        body :idle_max_wait_time
        body :idle_min_wait_time
        body :include_system
        body :initial_sync_max_wait_time
        body :max_connection_retries
        body :password
        body :request_timeout
        body :require_from_present
        body :restrict_collections
        body :restrict_type
        body :username
        body :verbose

        code 200, :success
        code 400, "Configuration is incomplete or malformed!"
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
      end
    end
  end
end
