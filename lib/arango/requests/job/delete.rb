module Arango
  # Arango Requests
  module Requests
    # Job Requests
    module Job
      # API: DELETE {/dbcontext}/_api/job/{type}#by_type
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/job/{type}#by_type'

        param :stamp

        code 200, :success
        code 400, "No job id given!"
        code 404, "Job unknown!"
      end
    end
  end
end
