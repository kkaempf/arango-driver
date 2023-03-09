module Arango
  module Requests
    module Collection
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/collection/{name}"

        code 200, :success
        code 404, "collection or view not found"
      end
    end
  end
end
