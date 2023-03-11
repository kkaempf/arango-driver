module Arango
  # Arango DocumentCollection
  module DocumentCollection
    # Arango DocumentCollection Importing
    module Importing
      # === IMPORT ===

      def import_documents

      end

      ## maybe not
      def import(attributes:, values:, fromPrefix: nil,
                 toPrefix: nil, overwrite: nil, wait_for_sync: nil,
                 onDuplicate: nil, complete: nil, details: nil)
        satisfy_category?(onDuplicate, [nil, "error", "update", "replace", "ignore"])
        satisfy_category?(overwrite, [nil, "yes", "true", true])
        satisfy_category?(complete, [nil, "yes", "true", true])
        satisfy_category?(details, [nil, "yes", "true", true])
        query = {
          collection:  @name,
          fromPrefix:  fromPrefix,
          toPrefix:    toPrefix,
          overwrite:   overwrite,
          waitForSync: wait_for_sync,
          onDuplicate: onDuplicate,
          complete:    complete,
          details:     details
        }
        body = "#{attributes}\n"
        values[0].is_a?(Array) ? values.each{|x| body += "#{x}\n"} : body += "#{values}\n"
        @database.request("POST", "_api/import", query: query, body: body)
      end

      def import_json(body:, type: "auto", fromPrefix: nil,
                      toPrefix: nil, overwrite: nil, wait_for_sync: nil,
                      onDuplicate: nil, complete: nil, details: nil)
        satisfy_category?(type, %w[auto list documents])
        satisfy_category?(onDuplicate, [nil, "error", "update", "replace", "ignore"])
        satisfy_category?(overwrite, [nil, "yes", "true", true])
        satisfy_category?(complete, [nil, "yes", "true", true])
        satisfy_category?(details, [nil, "yes", "true", true])
        query = {
          collection:  @name,
          type:        type,
          fromPrefix:  fromPrefix,
          toPrefix:    toPrefix,
          overwrite:   overwrite,
          waitForSync: wait_for_sync,
          onDuplicate: onDuplicate,
          complete:    complete,
          details:     details
        }
        @database.request("POST", "_api/import", query: query,
                          body: body)
      end
    end
  end
end
