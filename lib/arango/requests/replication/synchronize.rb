module Arango
  module Requests
    module Replication
      class Synchronize < Arango::Request
        request_method :put

        self.uri_template = '{/dbcontext}/_api/replication/sync'

        body :database
        body :endpoint
        body :include_system
        body :incremental
        body :initial_sync_max_wait_time
        body :password
        body :restrict_collections
        body :restrict_type
        body :username

        code 200, :success
        code 400, "Configuration is incomplete or malformed!"
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred during synchronization!"
        code 501, "Cannot be called on a cluster coordinater!"
      end
    end
  end
end
