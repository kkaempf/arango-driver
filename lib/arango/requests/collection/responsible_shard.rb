module Arango
  module Requests
    module Collection
      class ResponsibleShard < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/collection/{name}/responsibleShard"

        body_any

        code 200, :success
        code 400, "Collection name or shard keys missing!"
        code 404, "Collection is unknown!"
        code 501, "Not a cluster coordinator!"
      end
    end
  end
end
