module Arango
  module Requests
    module AQL
      class CurrentQueries < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/query/current"

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
