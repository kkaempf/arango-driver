module Arango
  module Requests
    # Replication Requests
    module Replication
      # API: PUT {/dbcontext}/_api/replication/make-slave
      class MakeSlave < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/replication/make-slave'

        body :adaptive_polling
        body :auto_resync
        body :auto_resync_retries
        body :chunk_size
        body :connect_timeout
        body :connection_retry_wait_time
        body :database
        body :endpoint
        body :idle_max_wait_time
        body :idle_min_wait_time
        body :include_system
        body :initial_sync_max_wait_time
        body :max_connect_retries
        body :password
        body :require_from_present
        body :restrict_collections
        body :restrict_type
        body :username
        body :verbose

        code 200, :success
        code 400, "Configuration is incomplete or malformed!"
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred during synchronization or when starting the continous replication!"
        code 501, "Cannot be called on a cluster coordinater!"
      end
    end
  end
end
