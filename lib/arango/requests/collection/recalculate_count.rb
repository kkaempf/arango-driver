module Arango
  module Requests
    module Collection
      class RecalculateCount < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/collection/{name}/recalculateCount"

        code 200, :success
        code 404, "Collection is unknown!"
      end
    end
  end
end
