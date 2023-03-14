module Arango
  module Requests
    # Cursor Requests
    module Cursor
      # API: PUT /_api/cursor/{id}
      class NextBatch < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/cursor/{id}"

        code 200, :success
        code 202, :success
        code 404, "Unknown cursor!"
      end
    end
  end
end
