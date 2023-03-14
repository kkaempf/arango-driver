module Arango
  # Arango Requests
  module Requests
    # Replication Requests
    module Replication
      # API: GET {/dbcontext}/_api/replication/applier-state
      class GetApplierState < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/replication/applier-state'

        code 200, :success
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
      end
    end
  end
end
