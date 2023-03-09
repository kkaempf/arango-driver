module Arango
  module Requests
    module Replication
      class CreateDumpBatch < Arango::Request
        request_method :post

        self.uri_template = '{/dbcontext}/_api/replication/batch'

        body :ttl

        code 200, :success
        code 400, "Ttl value is invalid!"
        code 405, "Invalid HTTP request method!"
      end
    end
  end
end
