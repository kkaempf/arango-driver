module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Foxx
      class ListAll < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/foxx'

        param :exclude_system

        code 200, :success
      end
    end
  end
end
