module Arango
  # Arango Database
  class Database
    # Arango Database Transactions
    # - not implemented -
    module Transactions
      # === TRANSACTION ===

      def transaction(action:, intermediate_commit_count: nil, intermediate_commit_size: nil, lock_timeout: nil, max_transaction_size: nil, params: nil,
                      read: [], wait_for_sync: nil, write: [])
        Arango::Transaction.new(action: action, database: self, intermediate_commit_count: intermediate_commit_count,
                                intermediate_commit_size: intermediate_commit_size, lock_timeout: lock_timeout,
                                max_transaction_size: max_transaction_size, params: params, read: read, wait_for_sync: wait_for_sync, write: write)
        # TODO execute
      end
    end
  end
end
