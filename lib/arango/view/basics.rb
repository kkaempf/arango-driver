module Arango
  #
  # Arango View
  #
  module View
    #
    # Arango View Basics
    #
    module Basics
      def exists?

      end

      def info


      end

      def rename(name:)
        body = {name: name}
        result = @database.request("PUT", "_api/view/#{@name}/rename", body: body)
        return_element(result)
      end#

      def drop
        @database.request("DELETE", "_api/view/#{@name}", key: :result)
      end
    end
  end
end
