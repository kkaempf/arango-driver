module Arango
  module Requests
    # Task Requests
    module Task
      # API: GET /_api/tasks
      class All < Arango::Request
        self.request_method = :get

        self.uri_template = '/_api/tasks'

        code 200, :success
      end
    end
  end
end
