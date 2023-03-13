module Arango
  module Requests
    # Collection Requests
    module Collection
      # API: PUT /_api/collection/{name}/truncate
      class Truncate < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/collection/{name}/truncate"

        code 200, :success
        code 400, "Collection name is missing!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
