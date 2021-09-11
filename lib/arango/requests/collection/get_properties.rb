module Arango
  module Requests
    module Collection
      class GetProperties < Arango::Request
        request_method :get

        uri_template "/_api/collection/{name}/properties"

        code 200, :success
        code 400, "Collection name missing!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
