module Arango
  module Requests
    module View
      class UpdateSearchViewProperties < Arango::Request
        self.request_method = :patch

        self.uri_template = '{/dbcontext}/_api/view/{name}/properties#ArangoSearch'

        body :cleanup_interval_step
        body :commit_interval_msec
        body :consolidation_interval_msec
        body :consolidation_policy
        body :links

        code 200, :success
        code 400, "View name is missing!"
        code 404, "View unknown!"
      end
    end
  end
end
