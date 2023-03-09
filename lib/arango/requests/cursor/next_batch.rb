module Arango
  module Requests
    module Cursor
      class NextBatch < Arango::Request
        request_method :put

        self.uri_template = "/_api/cursor/{id}"

        code 200, :success
        code 202, :success
        code 404, "Unknown cursor!"
      end
    end
  end
end
