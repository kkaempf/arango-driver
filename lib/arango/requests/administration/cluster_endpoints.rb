module Arango
  module Requests
    module Administration
      class ClusterEndpoints < Arango::Request
        request_method :get

        self.uri_template = "/_api/cluster/endpoints"

        code 200, :success
        code 501, "Cannot get cluster endpoints for some reason."
      end
    end
  end
end
