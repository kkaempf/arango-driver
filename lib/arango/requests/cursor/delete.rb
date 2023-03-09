module Arango
  module Requests
    module Cursor
      class Delete < Arango::Request
        request_method :delete

        self.uri_template = "/_api/cursor/{id}"

        code 202, :success
        code 404, "Unknown cursor!"
      end
    end
  end
end
