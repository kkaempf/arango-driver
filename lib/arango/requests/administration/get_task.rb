module Arango
  module Requests
    module Administration
      class GetTask < Arango::Request
        request_method :get

        self.uri_template = "/_api/tasks/{id}"

        code 200, :success
        code 404, "Task not found!"
      end
    end
  end
end
