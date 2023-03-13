module Arango
  module Requests
    # Collection Requests
    module Collection
      # API: PUT /_api/collection/{name}/rotate
      class RotateJournal < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/collection/{name}/rotate"

        code 200, :success
        code 400, "Collection has no journal!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
