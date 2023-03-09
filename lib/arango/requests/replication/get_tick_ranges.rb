module Arango
  module Requests
    module Replication
      class GetTickRanges < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/wal/range'

        code 200, :success
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
        code 501, "Cannot be called on a cluster coordinater!"
      end
    end
  end
end
