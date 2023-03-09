module Arango
  module Requests
    module Bulk
      class ImportDocument < Arango::Request
        self.request_method = :post

        self.uri_template = "/_api/import#document"

        param :collection, :required
        param :complete
        param :details
        param :from_prefix
        param :on_duplicate
        param :overwrite
        param :to_prefix
        param :wait_for_sync

        body_any

        code 201, :success
        code 400, "Type contains an invalid value, no collection is specified, the documents are incorrectly encoded or the request is malformed!"
        code 404, "Collection or the _from or _to attributes of an imported edge refer to an unknown collection!"
        code 409, "The import would trigger a unique key violation and complete is set to true!"
        code 500, "The server cannot auto-generate a document key (out of keys error) for a document with no user-defined key!"
      end
    end
  end
end
