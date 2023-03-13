module Arango
  # Arango Requests
  module Requests
    # Arango Document Requests
    module Document
      # API: PUT {/dbcontext}/_api/document/{collection}#get
      class GetMultiple < Arango::Request
        self.request_method = :put

        self.uri_template = '{/dbcontext}/_api/document/{collection}#get'

        param :onlyget, :required
        param :ignore_revs

        code 200, :success
        code 400, "Body does not contain a valid JSON representation of an array of documents!"
        code 404, "Collection not found!"
      end
    end
  end
end
