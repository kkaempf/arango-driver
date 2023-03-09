module Arango
  module Requests
    module AQL
      class ClearQueryResultCache < Arango::Request
        request_method :delete

        self.uri_template = "/_api/query-cache"

        param :namespace

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
