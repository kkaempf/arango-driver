module Arango
  # Arango DocumentCollection
  module DocumentCollection
    # Arango DocumentCollection Replication
    module Replication
      # === REPLICATION ===

      def data(batchId:, from: nil, to: nil, chunkSize: nil,
               includeSystem: nil, failOnUnknown: nil, ticks: nil, flush: nil)
        query = {
          collection: @name,
          batchId:    batchId,
          from:       from,
          to:         to,
          chunkSize:  chunkSize,
          includeSystem:  includeSystem,
          failOnUnknown:  failOnUnknown,
          ticks: ticks,
          flush: flush
        }
        @database.request("GET", "_api/replication/dump", query: query)
      end
      alias dump data
    end
  end
end
