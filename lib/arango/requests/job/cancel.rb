module Arango
  # Arango Requests
  module Requests
    # Job Requests
    module Job
      # API: PUT {/dbcontext}/_api/job/{id}/cancel
      class Cancel < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/job/{id}/cancel'

        code 200, :success
        code 400, "No type given or type invalid!"
        code 404, "Job unknown!"
      end
    end
  end
end
