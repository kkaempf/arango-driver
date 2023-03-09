module Arango
  module Requests
    module Replication
      class StopApplier < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/replication/applier-stop'

        code 200, :success
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
      end
    end
  end
end
