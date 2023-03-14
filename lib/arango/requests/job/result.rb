module Arango
  module Requests
    # Job Requests
    module Job
      # API: PUT {/dbcontext}/_api/job/{id}
      class Result < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/job/{id}'

        code 204, :success
        code 400, "No job id given!"
        code 404, "Job unknown!"
      end
    end
  end
end
