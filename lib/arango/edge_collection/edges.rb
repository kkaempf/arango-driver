module Arango
  # Arango EdgeCollection
  module EdgeCollection
    # Arango EdgeCollection Edges
    module Edges
      def new_edge(key: nil, attributes: {}, from: nil, to: nil, wait_for_sync: nil)
        Arango::Edge::Base.new(key: key, attributes: attributes, from: from, to: to, edge_collection: self, wait_for_sync: wait_for_sync)
      end

      def create_edge(key: nil, attributes: {}, from: nil, to: nil, wait_for_sync: nil)
        Arango::Edge::Base.new(key: key, attributes: attributes, from: from, to: to, edge_collection: self, wait_for_sync: wait_for_sync).create
      end

      def create_edges(array_of_property_hashes, wait_for_sync: nil)
        Arango::Edge::Base.create_edges(array_of_property_hashes, edge_collection: self, wait_for_sync: wait_for_sync)
      end

      def edge_exists?(key: nil, attributes: {}, match_rev: nil)
        Arango::Edge::Base.exists?(key: key, attributes: attributes, match_rev: match_rev, edge_collection: self)
      end

      def get_edge(key: nil, attributes: {})
        Arango::Edge::Base.get(key: key, attributes: attributes, edge_collection: self)
      end
      alias fetch_edge get_edge
      alias retrieve_edge get_edge

      def get_edges(keys)
        Arango::Edge::Base.get_edges(keys, edge_collection: self)
      end
      alias fetch_edges get_edges
      alias retrieve_edges get_edges

      def find_edges_matching(attributes)
        Arango::Edge::Base.find_edges_matching(attributes, edge_collection: self)
      end

      def all_edges(offset: 0, limit: nil, batch_size: nil)
        Arango::Edge::Base.all(offset: offset, limit: limit, batch_size: batch_size, edge_collection: self)
      end

      def list_edges(offset: 0, limit: nil, batch_size: nil)
        Arango::Edge::Base.list(offset: offset, limit: limit, batch_size: batch_size, edge_collection: self)
      end

      def replace_edge(edge)
        Arango::Edge::Base.replace(edge)
      end

      def replace_edges(edges_array, wait_for_sync: nil, ignore_revs: nil, return_old: nil, return_new: nil)
        Arango::Edge::Base.replace_edges(edges_array, wait_for_sync: wait_for_sync, ignore_revs: ignore_revs,
                                         return_old: return_old, return_new: return_new)
      end

      def save_edge(edge)
        Arango::Edge::Base.save(edge)
      end
      alias update_edge save_edge

      def save_edges(edges_array, wait_for_sync: nil, ignore_revs: nil)
        Arango::Edge::Base.save_edges(edges_array, wait_for_sync: wait_for_sync, ignore_revs: ignore_revs)
      end
      alias update_edges save_edges

      def delete_edge(key: nil, attributes: {})
        Arango::Edge::Base.delete(key: key, attributes: attributes, edge_collection: self)
      end

      def delete_edges(edges_array)
        Arango::Edge::Base.delete_edges(edges_array, edge_collection: self)
      end
    end
  end
end
