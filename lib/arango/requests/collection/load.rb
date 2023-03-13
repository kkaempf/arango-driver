module Arango
  module Requests
    # Collection Requests
    module Collection
      # API: PUT /_api/collection/{name}/load
      class Load < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/collection/{name}/load"

        code 200, :success
        code 400, "Collection name missing!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
