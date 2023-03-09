module Arango
  module Requests
    module Collection
      class Statistics < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/collection/{name}/figures"

        code 200, :success
        code 400, "Collection name is missing!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
