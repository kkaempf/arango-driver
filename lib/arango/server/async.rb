module Arango
  # Arango Server
  class Server
    # Arango Server Async
    module Async
      # === ASYNC ===

      def fetch_async(id:)
        request("PUT", "_api/job/#{id}")
      end

      def cancel_async(id:)
        request("PUT", "_api/job/#{id}/cancel", key: :result)
      end

      def destroy_async(id:, stamp: nil)
        query = {stamp: stamp}
        request("DELETE", "_api/job/#{id}", query: query, key: :result)
      end

      def destroy_async_by_type(type:, stamp: nil)
        satisfy_category?(type, %w[all expired])
        query = {stamp: stamp}
        request("DELETE", "_api/job/#{type}", query: query)
      end

      def destroy_all_async
        destroy_async_by_type(type: "all")
      end

      def destroy_expired_async
        destroy_async_by_type(type: "expired")
      end

      def retrieve_async(id:)
        request("GET", "_api/job/#{id}")
      end

      def retrieve_async_by_type(type:, count: nil)
        satisfy_category?(type, %w[done pending])
        request("GET", "_api/job/#{type}", query: {count: count})
      end

      def retrieve_done_async(count: nil)
        retrieve_async_by_type(type: "done", count: count)
      end

      def retrieve_pending_async(count: nil)
        retrieve_async_by_type(type: "pending", count: count)
      end
    end
  end
end
