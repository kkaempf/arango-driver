module Arango
  # Arango Requests
  module Requests
    # Replication Requests
    module Replication
      # API: DELETE {/dbcontext}/_api/replication/batch/{id}
      class DeleteDumpBatch < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/replication/batch/{id}'

        code 204, :success
        code 400, "Ttl value is invalid!"
        code 405, "Invalid HTTP request method!"
      end
    end
  end
end
