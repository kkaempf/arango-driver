module Arango
  module Requests
    module Task
      class Get < Arango::Request
        request_method :get

        self.uri_template = '/_api/tasks/{id}'

        code 200, :success
        code 404, "Task #{@id} not found"
      end
    end
  end
end
