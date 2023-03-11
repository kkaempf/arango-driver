module Arango
  # Arango Edge
  module Edge
    # Arango Edge InstanceMethods
    module InstanceMethods

      def initialize(key: nil, attributes: {}, from: nil, to: nil, edge_collection:, ignore_revs: false, wait_for_sync: false)
        @attributes = _attributes_from_arg(attributes)
        @attributes[:_key] = key if key
        #STDERR.puts ("Edge.new key #{key.inspect}, attributes #{attributes.inspect}, from #{from.inspect}, to #{to.inspect}")
        @changed_attributes = {}
        @ignore_revs = ignore_revs
        @wait_for_sync = wait_for_sync
        _set_from(from || from_id)
        _set_to(to || to_id)
        send(:edge_collection=, edge_collection)
        send(:graph=, edge_collection.graph) if edge_collection.graph
      end

      def id
        i = @changed_attributes[:_id] || @attributes[:_id]
        return i if i
        "#{edge_collection.name}/#{key}"
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
        @attributes.delete_if{ |_,v| v.nil? }
      end

      attr_accessor :ignore_revs, :wait_for_sync
      attr_reader :edge_collection, :graph, :database, :server, :attributes

      def attributes=(doc)
        @changed_attributes = _attributes_from_arg(doc)
      end

      def edge_collection=(edge_collection)
        satisfy_module?(edge_collection, Arango::EdgeCollection::Mixin)
        @edge_collection = edge_collection
        @graph = @edge_collection.graph
        @database = @edge_collection.database
        @server = @database.server
      end

      def graph=(graph)
        satisfy_module?(graph, Arango::Graph::Mixin)
        @graph = graph
        @database = @graph.database
        @server = @graph.server
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

      def reload
        headers = nil
        headers = { "If-Match": @attributes[:_rev] } if !@ignore_revs && @attributes.key?(:_rev)
        args = { collection: @edge_collection.name, key: @attributes[:_key] }
        result = Arango::Requests::Document::Get.execute(server: @server, headers: headers, args: args)
        @attributes = _attributes_from_arg(result)
        @changed_attributes = {}
        self
      end

      def same_revision?
        headers = { "If-Match": @attributes[:_rev] }
        args = { collection: @edge_collection.name, key: @attributes[:_key] }
        begin
          Arango::Requests::Document::Head.execute(server: @server, headers: headers, args: args)
        rescue Error => e
          return false
        end
        true
      end

      def create
        params = { returnNew: true }
        params[:waitForSync] = @wait_for_sync unless @wait_for_sync.nil?
        @attributes = @attributes.merge(@changed_attributes)
        @changed_attributes = {}
        args = { collection: @edge_collection.name }
        result = Arango::Requests::Document::Create.execute(server: @server, args: args, params: params, body: @attributes)
        @attributes.merge!(result[:new])
        self
      end

      def replace
        params = { returnNew: true, ignoreRevs: @ignore_revs }
        params[:waitForSync] = @wait_for_sync unless @wait_for_sync.nil?
        headers = nil
        attributes = @changed_attributes
        attributes[:_id] = @attributes[:_id]
        attributes[:_key] = @attributes[:_key]
        attributes[:_rev] = @attributes[:_rev]
        attributes[:_from] = from_id
        attributes[:_to] = to_id
        @attributes = attributes
        @changed_attributes = {}
        headers = { "If-Match": @attributes[:_rev] } if !@ignore_revs && @attributes.key?(:_rev)
        args = { collection: @edge_collection.name, key: @attributes[:_key] }
        result = Arango::Requests::Document::Replace.execute(server: @server, args: args, params: params, headers: headers, body: @attributes)
        @attributes.merge!(result[:new])
        self
      end

      def save
        params = { returnNew: true, ignoreRevs: @ignore_revs }
        params[:waitForSync] = @wait_for_sync unless @wait_for_sync.nil?
        headers = nil
        headers = { "If-Match": @attributes[:_rev] } if !@ignore_revs && @attributes.key?(:_rev)
        changed_attributes = @changed_attributes
        @changed_attributes = {}
        args = { collection: @edge_collection.name, key: @attributes[:_key] }
        result = Arango::Requests::Document::Update.execute(server: @server, args: args, params: params, headers: headers, body: changed_attributes)
        @attributes.merge!(result[:new])
        self
      end
      alias update save

      def delete
        params = { waitForSync: @wait_for_sync }
        headers = nil
        headers = { "If-Match": @attributes[:_rev] } if !@ignore_revs && @attributes.key?(:_rev)
        args = { collection: @edge_collection.name, key: @attributes[:_key] }
        Arango::Requests::Document::Delete.execute(server: @server, args: args, params: params, headers: headers)
        nil
      end

      def from
        @from_instance ||= _get_instance(from_id)
      end

      def from_id
        @changed_attributes[:_from] || @attributes[:_from]
      end

      def from=(f)
        _set_from(f)
        from_id
      end

      def to
        @to_instance ||= _get_instance(to_id)
      end

      def to_id
        @changed_attributes[:_to] || @attributes[:_to]
      end

      def to=(t)
        _set_to(t)
        to_id
      end

      private

      def _attributes_from_arg(arg)
        return {} unless arg
        case arg
        when String then { _key: arg }
        when Hash
          arg.transform_keys!(&:to_sym)
          arg[:_id] = arg.delete(:id) if arg.key?(:id) && !arg.key?(:_id)
          arg[:_key] = arg.delete(:key) if arg.key?(:key) && !arg.key?(:_key)
          arg[:_rev] = arg.delete(:rev) if arg.key?(:rev) && !arg.key?(:_rev)
          arg[:_from] = arg.delete(:from) if arg.key?(:from) && !arg.key?(:_from)
          arg[:_to] = arg.delete(:to) if arg.key?(:to) && !arg.key?(:_to)
          arg.delete_if{|_,v| v.nil?}
          arg
        when Arango::Edge::Mixin then arg.to_h
        when Arango::Result then arg.to_h
        else
          raise "Unknown arg type, must be String, Hash, Arango::Result or Arango::Edge::Mixin."
        end
      end

      def _get_instance(id)

      end
      # def _get_instance do |id|
      #   params = { returnNew: true }
      #   params[:waitForSync] = @wait_for_sync unless @wait_for_sync.nil?
      #   @attributes = @attributes.merge(@changed_attributes)
      #   @changed_attributes = {}
      #   { post: "_api/document/#{@edge_collection.name}", body: @attributes, params: params,
      #     block: ->(result) do
      #       @attributes.merge!(result[:new])
      #       self
      #     end
      #   }
      # end

      def _set_from(f)
        raise "from must be given" unless f
        if f.class == String
          @attributes[:_from] = f
          @from_instance = nil
        elsif f.is_a?(Arango::Document::Mixin)
          @attributes[:_from] = f.id
          @from_instance = f
        else
          raise "from (of type #{f.class}) is not valid"
        end
      end

      def _set_to(t)
        raise "to must be given" unless t
        if t.class == String
          @attributes[:_to] = t
          @to_instance = nil
        elsif t.is_a?(Arango::Document::Mixin)
          @attributes[:_to] = t.id
          @to_instance = t
        else
          raise "to (of type #{t.class}) is not valid"
        end
      end
    end
  end
end
