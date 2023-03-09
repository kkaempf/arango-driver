module Arango
  module Requests
    module Collection
      class RotateJournal < Arango::Request
        request_method :put

        self.uri_template = "/_api/collection/{name}/rotate"

        code 200, :success
        code 400, "Collection has no journal!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
