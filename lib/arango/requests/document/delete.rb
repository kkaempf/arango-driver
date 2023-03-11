module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Document
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '{/dbcontext}/_api/document/{collection}/{key}'

        header 'If-Match'

        param :return_old
        param :silent
        param :wait_for_sync

        code 200, :success
        code 202, :success
        code 404, "Collection not found!"
        code 412, "If-Match header or rev was given but the found document has a different version!"
      end
    end
  end
end
