module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Collection
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/collection/{name}"

        param :is_system

        code 200, :success
        code 400, "Collection name is missing!"
        code 404, "collection or view not found"
      end
    end
  end
end
