module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Administration
      class Availability < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/server/availability"

        code 200, :success
        code 503, "Server is starting or shutting down, is set to read-only mode or is currently a follower in an active failover setup."
      end
    end
  end
end
