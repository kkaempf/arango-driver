module Arango
  # Arango Requests
  module Requests
    # Cursor Requests
    module Cursor
      # API: DELETE /_api/cursor/{id}
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/cursor/{id}"

        code 202, :success
        code 404, "Unknown cursor!"
      end
    end
  end
end
