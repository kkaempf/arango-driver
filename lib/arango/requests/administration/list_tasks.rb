module Arango
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_api/tasks/
      class ListTasks < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/tasks/"

        code 200, :success
      end
    end
  end
end
