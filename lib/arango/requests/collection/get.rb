module Arango
  # Arango Requests
  module Requests
    # Collection Requests
    module Collection
      # API: GET /_api/collection/{name}
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/collection/{name}"

        code 200, :success
        code 404, "collection or view not found"
      end
    end
  end
end
