module Arango
  module Requests
    module Job
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/job/{id}'

        code 200, :success
        code 204, :success
        code 404, "Job unknown!"
      end
    end
  end
end
