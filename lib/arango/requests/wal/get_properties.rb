module Arango
  # Arango Requests
  module Requests
    # Wal Requests
    module Wal
      # API: GET /_admin/wal/properties
      class GetProperties < Arango::Request
        self.request_method = :get

        self.uri_template = "/_admin/wal/properties"

        code 200, :success
        code 405, "Invalid HTTP method!"
        code 501, "Invalid: called on cluster coordinator"
      end
    end
  end
end
