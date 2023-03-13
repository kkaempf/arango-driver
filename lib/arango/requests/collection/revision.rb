module Arango
  module Requests
    # Collection Requests
    module Collection
      # API: GET /_api/collection/{name}/revision
      class Revision < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/collection/{name}/revision"

        code 200, :success
        code 400, "Collection name missing!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
