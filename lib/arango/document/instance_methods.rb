module Arango
  # Arango Document
  module Document
    # Arango Document InstanceMethods
    module InstanceMethods

      attr_accessor :ignore_revs, :wait_for_sync
      attr_reader :graph, :collection, :database, :server, :attributes

      def initialize(key: nil, attributes: {}, collection:, ignore_revs: false, wait_for_sync: nil)
        @attributes = _attributes_from_arg(attributes)
        @attributes[:_key] = key if key
        @changed_attributes = {}
        @ignore_revs = ignore_revs
        @wait_for_sync = wait_for_sync
        send(:collection=, collection)
        send(:graph=, collection.graph) if collection.graph
      end
      
      def attributes=(doc)
        @changed_attributes = _attributes_from_arg(doc)
        #set_up_from_or_to("from", result[:_from])
        #set_up_from_or_to("to", result[:_to])
      end

      def collection=(collection)
        satisfy_module?(collection, Arango::DocumentCollection::Mixin)
        @collection = collection
        @graph = @collection.graph
        @database = @collection.database
        @server = @database.server
      end

      def graph=(graph)
        satisfy_module?(graph, Arango::Graph::Mixin)
        @graph = graph
        @database = @graph.database
        @server = @graph.server
      end

      def id
        i = @changed_attributes[:_id] || @attributes[:_id]
        return i if i
        "#{collection.name}/#{key}"
      end

      def id=(i)
        @changed_attributes[:_id] = i
      end

      def key
        @changed_attributes[:_key] || @attributes[:_key]
      end

      def key=(k)
        @changed_attributes[:_key] = k
      end

      def revision
        @changed_attributes[:_rev] || @attributes[:_rev]
      end

      def revision=(r)
        @changed_attributes[:_rev] = r
      end

      def to_h
        @attributes.delete_if{|_,v| v.nil?}
      end

      def vertex?
        !!@graph
      end

      def method_missing(name, *args, &block)
        name_s = name.to_s
        set_attr = false
        have_attr = false
        attribute_name_s = name_s.end_with?('=') ? (set_attr = true; name_s.chop) : name_s
        attribute_name_y = attribute_name_s.start_with?('attribute_') ? (have_attr = true; attribute_name_s[9..-1].to_sym) : attribute_name_s.to_sym
        if set_attr
          return @changed_attributes[attribute_name_y] = args[0]
        elsif @changed_attributes.key?(attribute_name_y)
          return @changed_attributes[attribute_name_y]
        elsif @attributes.key?(attribute_name_y)
          return @attributes[attribute_name_y]
        elsif have_attr
          return nil
        end
        super(name, *args, &block)
      end

      def create
        params = { returnNew: true }
        params[:waitForSync] = @wait_for_sync unless @wait_for_sync.nil?
        @attributes.merge!(@changed_attributes)
        @changed_attributes = {}
        result = if @graph
          Arango::Requests::Graph::CreateVertex.execute(server: @server, args: @attributes, params: params)
        else
          args = { collection: @collection.name }
          Arango::Requests::Document::Create.execute(server: @server, args: args, body: @attributes, params: params)
        end
        @attributes.merge!(result.new)
        self
      end

      def reload
        headers = {}
        result = if @graph
          headers[:"If-Match"] = @attributes[:_rev] if if_match
          args = { collection: @collection.name, vertex: @attributes[:_key] }
          Arango::Requests::Graph::GetVertex.execute(server: @server, headers: headers, args: args)
        else
          headers = { "If-Match": @attributes[:_rev] } if !@ignore_revs && @attributes.key?(:_rev)
          args = { collection: @collection.name, key: @attributes[:_key] }
          Arango::Requests::Document::Get.execute(server: @server, headers: headers, args: args)
        end
        @attributes = _attributes_from_arg(result)
        @changed_attributes = {}
      end

      # is the same revision stored in the DB ?
      def same_revision?
        headers = { "If-Match": @attributes[:_rev] }
        args = { collection: @collection.name, key: @attributes[:_key] }
        begin
          Arango::Requests::Document::Head.execute(server: @server, headers: headers, args: args)
        rescue Error => e
          return false
        end
        true
      end

      def replace
        headers = {}
        result = if @graph
          headers[:"If-Match"] = @attributes[:_rev] if if_match
          args = { graph: @graph.name, collection: @collection.name, vertex: @attributes[:_key] }
          Arango::Requests::Graph::UpdateVertex.execute(server: @server, args: args, headers: headers)
        else
          query = { returnNew: true, ignoreRevs: @ignore_revs }
          query[:waitForSync] = @wait_for_sync unless @wait_for_sync.nil?
          headers = nil
          attributes = @changed_attributes
          attributes[:_id] = @attributes[:_id]
          attributes[:_key] = @attributes[:_key]
          attributes[:_rev] = @attributes[:_rev]
          @attributes = attributes
          @changed_attributes = {}
          headers = { "If-Match": @attributes[:_rev] } if !@ignore_revs && @attributes.key?(:_rev)
          args = { collection: @collection.name, key: @attributes[:_key] }
          Arango::Requests::Document::Update.execute(server: @server, args: args, headers: headers, body: @attributes)
        end
        @attributes.merge!(@attributes)
        self
      end

      def save
        headers = { }
        result = if @graph
          headers[:"If-Match"] = @attributes[:_rev] if if_match
          args = { graph: @graph.name, collection: @collection.name, vertex: @attributes[:_key] }
          Arango::Requests::Graph::UpdateVertex.execute(server: @server, args: args, headers: headers)
        else
          query = { returnNew: true, ignoreRevs: @ignore_revs }
          query[:waitForSync] = @wait_for_sync unless @wait_for_sync.nil?
          headers[:"If-Match"] =  @attributes[:_rev] if !@ignore_revs && @attributes.key?(:_rev)
          changed_attributes = @changed_attributes
          @changed_attributes = {}
          args = { collection: @collection.name, key: @attributes[:_key] }
          rev = Arango::Requests::Document::Update.execute(server: @server, args: args, headers: headers, body: changed_attributes)[:_rev]
          changed_attributes.merge({ _rev: rev })
        end
        @attributes.merge!(result)
        self
      end
      alias update save

      def delete
        headers = { }
        if @graph
          headers[:"If-Match"] = @attributes[:_rev] if if_match
          args = { graph: @graph.name, collection: @collection.name, vertex: @attributes[:_key] }
          Arango::Requests::Graph::Delete.execute(server: @server, args: args, headers: headers)
        else
          query = { waitForSync: @wait_for_sync }
          headers[:"If-Match"] = @attributes[:_rev] if !@ignore_revs && @attributes.key?(:_rev)
          args = { collection: @collection.name, key: @attributes[:_key] }
          Arango::Requests::Document::Delete.execute(server: @server, args: args, headers: headers)
        end
        nil
      end

      private

      def _attributes_from_arg(arg)
        case arg
        when String then { _key: arg }
        when Hash
          arg.transform_keys!(&:to_sym)
          arg[:_id] = arg.delete(:id) if arg.key?(:id) && !arg.key?(:_id)
          arg[:_key] = arg.delete(:key) if arg.key?(:key) && !arg.key?(:_key)
          arg[:_rev] = arg.delete(:rev) if arg.key?(:rev) && !arg.key?(:_rev)
          arg.delete_if{|_,v| v.nil?}
          arg
        when Arango::Document::Mixin then arg.to_h
        when Arango::Result then arg.to_h
        else
          raise "Unknown arg type '#{arg.class}', must be String, Hash, Arango::Result or Arango::Document but was #{arg.class}"
        end
      end
    end
  end
end
