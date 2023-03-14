module Arango
  # Arango Requests
  module Requests
    # Cluster Requests
    module Cluster
      # API: GET /_admin/cluster/health
      class Health < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/cluster/health"

        code 201, :success
      end
    end
  end
end
