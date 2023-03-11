module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Bulk
      class Execute < Arango::Request
        self.request_method = :post

        self.uri_template = "/_api/batch"

        # TODO
        # body_is_string

        code 200, :success
        code 400, "Batch envelope malformed or incorrectly formatted!"
        code 405, "Invalid HTTP method!"
      end
    end
  end
end
