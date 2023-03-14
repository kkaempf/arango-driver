module Arango
  # Arango Requests
  module Requests
    # Replication Requests
    module Replication
      # API: POST {/dbcontext}/_api/replication/batch
      class CreateDumpBatch < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/replication/batch'

        body :ttl

        code 200, :success
        code 400, "Ttl value is invalid!"
        code 405, "Invalid HTTP request method!"
      end
    end
  end
end
