module Arango
  module Requests
    module Collection
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
