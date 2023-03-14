module Arango
  # Arango Graph
  module Graph
    # Arango Graph ClassMethods
    module ClassMethods
      # Create Arango::Graph from hash
      def from_h(graph_hash, database: Arango.current_database)
        graph_hash = graph_hash.transform_keys { |k| k.to_s.underscore.to_sym }
        graph_hash.merge!(database: database) unless graph_hash.has_key?(:database)
        if graph_hash.has_key?(:properties)
          graph_hash[:name] = graph_hash[:properties].delete(:name) if graph_hash[:properties].has_key?(:name)
        end
        Arango::Graph::Base.new(**graph_hash)
      end

      # Takes a Arango::Result and instantiates a Arango::Graph::Base object from it.
      # @param graph_result [Arango::Result]
      # @param properties_result [Arango::Result]
      # @return [Arango::Graph::Base]
      def from_results(graph_result, properties_result, database: Arango.current_database)
        hash = graph_result ? {}.merge(graph_result.to_h) : {}
        hash[:properties] = properties_result
        from_h(hash, database: database)
      end

      # extend Arango::Graph with class methods
      def self.extended(base)

        # Retrieves all graphs from the database.
        # @param database [Arango::Database]
        # @return [Array<Arango::Graph::Base>]
        def all (database: Arango.current_database)
          result = Arango::Requests::Graph::ListAll.execute(server: database.server)
          result.graphs.map { |c| from_results({}, c.to_h, database: database) }
        end

        # Get graph from the database.
        # @param name [String] The name of the graph.
        # @param database [Arango::Database]
        # @return [Arango::Database]
        def get (name:, database: Arango.current_database)
          args = { graph: name }
          result = Arango::Requests::Graph::Get.execute(server: database.server, args: args)
          from_results({}, result.graph, database: database)
        end

        # Retrieves a list of all graphs.
        # @param database [Arango::Database]
        # @return [Array<String>] List of graph names.
        def list (database: Arango.current_database)
          result = Arango::Requests::Graph::ListAll.execute(server: database.server)
          result.graphs.map { |c| c[:name] }
        end

        # Removes a graph.
        # @param name [String] The name of the graph.
        # @param database [Arango::Database]
        # @return nil
        def delete(name:, database: Arango.current_database)
          args = { graph: name }
          result = Arango::Requests::Graph::Delete.execute(server: database.server, args: args)
        end

        # Check if graph exists.
        # @param name [String] Name of the graph
        # @param database [Arango::Database]
        # @return [Boolean]
        def exists? (name:, database: Arango.current_database)
          args = { name: name }
          result = Arango::Requests::Graph::Get.execute(server: database.server, args: args)
          result.graphs.map { |c| c[:name] }.include?(name)
        end
      end

      # Create Graph in database
      def create(is_smart: @is_smart, smart_graph_attribute: @smart_graph_attribute,
                 number_of_shards: @number_of_shards)
        body = {
          name: @name,
          edgeDefinitions:   edge_definitions_raw,
          isSmart: is_smart,
          options: {
            smartGraphAttribute: smart_graph_attribute,
            numberOfShards: number_of_shards
          }
        }
        body[:options].delete_if{|k,v| v.nil?}
        body.delete(:options) if body[:options].empty?
        result = Arango::Requests::Graph::Create.execute(server: @database.server, body: body, key: :graph)
        return_element(result)
      end
    end
  end
end
