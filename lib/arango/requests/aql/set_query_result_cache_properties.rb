module Arango
  module Requests
    module AQL
      class SetQueryResultCacheProperties < Arango::Request
        request_method :put

        uri_template "/_api/query-cache/properties"

        body :include_system
        body :max_entry_size
        body :max_results
        body :max_results_size
        body :mode

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
