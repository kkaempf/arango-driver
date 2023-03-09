module Arango
  module Requests
    module Collection
      class Shards < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/collection/{name}/shards"

        param :details

        code 200, :success
        code 400, "Collection name missing!"
        code 404, "Collection is unknown!"
        code 501, "Not a cluster coordinator!"
      end
    end
  end
end
