module Arango
  module Requests
    module Task
      class All < Arango::Request
        request_method :get

        self.uri_template = '/_api/tasks'

        code 200, :success
      end
    end
  end
end
