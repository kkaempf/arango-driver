module Arango
  module Requests
    module Administration
      class ListTasks < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/tasks/"

        code 200, :success
      end
    end
  end
end
