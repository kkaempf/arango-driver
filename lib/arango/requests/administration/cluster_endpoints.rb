module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_api/cluster/endpoints
      class ClusterEndpoints < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/cluster/endpoints"

        code 200, :success
        code 501, "Cannot get cluster endpoints for some reason."
      end
    end
  end
end
