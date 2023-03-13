module Arango
  # Arango Requests
  module Requests
    # Collection Requests
    module Collection
      # API: GET /_api/collection/{name}/properties
      class GetProperties < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/collection/{name}/properties"

        code 200, :success
        code 400, "Collection name missing!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
