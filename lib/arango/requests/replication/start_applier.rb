module Arango
  module Requests
    module Replication
      class StartApplier < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/replication/applier-start'

        param :from

        code 200, :success
        code 400, "Applier not fully configured or the configuration is invalid!"
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
      end
    end
  end
end
