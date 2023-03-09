module Arango
  module Requests
    module Index
      class ListAll < Arango::Request
        request_method :get

        self.uri_template = '{/dbcontext}/_api/index'

        param :collection, :required
        
        code 200, :success
      end
    end
  end
end
