module Arango
  module Requests
    module AQL
      class SetQueryTrackingProperties < Arango::Request
        request_method :put

        self.uri_template = "/_api/query/properties"

        body :enabled
        body :max_query_string_length
        body :max_slow_queries
        body :slow_query_threshold
        body :track_slow_queries
        body :track_bind_vars

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
