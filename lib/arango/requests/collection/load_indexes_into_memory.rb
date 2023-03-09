module Arango
  module Requests
    module Collection
      class LoadIndexesIntoMemory < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/collection/{name}/loadIndexesIntoMemory"

        code 200, :success
        code 400, "Collection name missing!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
