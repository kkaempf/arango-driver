module Arango
  module Requests
    module AQL
      class ListFunctions < Arango::Request
        request_method :get

        self.uri_template = "/_api/aqlfunction"

        param :namespace

        code 200, :success
        code 400, "Function name malformed!"
      end
    end
  end
end
