module Arango
  module Requests
    module View
      class ListAll < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/view'

        code 200, :success
      end
    end
  end
end
