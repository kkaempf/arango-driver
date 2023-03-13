module Arango
  module Requests
    # AQL Requests
    module AQL
      # API: PUT /_api/query/properties
      class SetQueryTrackingProperties < Arango::Request
        self.request_method = :put

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
