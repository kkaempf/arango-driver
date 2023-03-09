module Arango
  module Requests
    module Wal
      class GetProperties < Arango::Request
        request_method :get

        self.uri_template = "/_admin/wal/properties"

        code 200, :success
        code 405, "Invalid HTTP method!"
      end
    end
  end
end
