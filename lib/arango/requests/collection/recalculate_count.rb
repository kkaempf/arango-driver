module Arango
  module Requests
    # Collection Requests
    module Collection
      # API: PUT /_api/collection/{name}/recalculateCount
      class RecalculateCount < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/collection/{name}/recalculateCount"

        code 200, :success
        code 404, "Collection is unknown!"
      end
    end
  end
end
