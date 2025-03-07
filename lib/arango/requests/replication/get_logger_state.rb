module Arango
  # Arango Requests
  module Requests
    # Replication Requests
    module Replication
      # API: GET {/dbcontext}/_api/replication/logger-tick-ranges
      class GetLoggerTickRanges < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/replication/logger-tick-ranges'

        code 200, :success
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
      end
    end
  end
end
