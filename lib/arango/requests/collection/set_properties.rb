module Arango
  module Requests
    # Collection Requests
    module Collection
      # API: PUT /_api/collection/{name}/properties
      class SetProperties < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/collection/{name}/properties"

        body :journal_size
        body :wait_for_sync

        code 200, :success
        code 400, "Collection name missing!"
        code 404, "Collection is unknown!"
      end
    end
  end
end
