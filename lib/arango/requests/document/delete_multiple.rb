module Arango
  # Arango Requests
  module Requests
    # Arango Document Requests
    module Document
      # API: DELETE {/dbcontext}/_api/document/{collection}
      class DeleteMultiple < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/document/{collection}'

        param :ignore_revs
        param :return_old
        param :wait_for_sync

        body_array

        code 200, :success
        code 202, :success
        code 404, "Collection not found!"
      end
    end
  end
end
