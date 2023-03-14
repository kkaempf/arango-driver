module Arango
  module Requests
    # Replication Requests
    module Replication
      # API: PUT {/dbcontext}/_api/replication/batch/{id}
      class ProlongDumpBatch < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/replication/batch/{id}'

        body :ttl

        code 204, :success
        code 400, "Ttl value is invalid!"
        code 405, "Invalid HTTP request method!"
      end
    end
  end
end
