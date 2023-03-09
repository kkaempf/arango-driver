module Arango
  module Requests
    module AQL
      class DeleteSlowQueryList < Arango::Request
        request_method :delete

        self.uri_template = "/_api/query/slow"

        code 200, :success
        code 400, "Malformed request!"
      end
    end
  end
end
