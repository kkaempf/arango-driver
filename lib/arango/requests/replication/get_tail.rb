module Arango
  # Arango Requests
  module Requests
    # Replication Requests
    module Replication
      # API: GET {/dbcontext}/_api/wal/tail
      class GetTail < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/wal/tail'

        param :barrier_id
        param :chunk_size
        param :client_info
        param :from
        param :global
        param :last_scanned
        param :server_id
        param :syncer_id
        param :to

        code 200, :success
        code 204, :success
        code 400, "From or to value are invalid!"
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
        code 501, "Cannot be called on a cluster coordinater!"
      end
    end
  end
end
