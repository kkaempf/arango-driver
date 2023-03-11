module Arango
  #
  # Arango View
  #
  class View
    include Arango::Helper::Satisfaction

    include Arango::Helper::DatabaseAssignment

    def initialize(database:, type: "arangosearch", name:, id: nil, cache_name: nil)
      assign_database(database)
      unless cache_name.nil?
        @cache_name = cache_name
        @server.cache.save(:view, cache_name, self)
      end
      satisfy_category?(type, ["arangosearch"])
      @type = type
      @name = name
      @links = {}
      @id = id
    end

# === DEFINE ===

    attr_reader :type, :links, :database, :cache_name
    attr_accessor :id, :name

    def type=(type)
      satisfy_category?(type, ["arangosearch"])
      @type = type
    end
    alias assign_type type=

    def add_link(collection:, analyzers: nil, fields: {}, include_all_fields: nil, track_list_positions: nil, store_values: nil)
      satisfy_class?(collection, [Arango::DocumentCollection, String])
      collection_name = collection.is_a?(String) ? collection : collection.name
      satisfy_category?(store_values, ["none", "id", nil])
      @links[collection_name] = {
        analyzers: analyzers,
        fields: fields,
        includeAllFields: include_all_fields,
        trackListPositions: track_list_positions,
        storeValues: store_values
      }
      @links[collection_name].delete_if{|k,v| v.nil?}
    end

    def to_h
      {
        name: @name,
        id: @id,
        type: @type,
        links: @links,
        cache_name: @cache_name,
        database: @database.name
      }.delete_if{|k,v| v.nil?}
    end

    def body=(result)
      @body  = result
      @id    = result[:id] || @id
      @type  = assign_type(result[:type] || @type)
      @links = result[:links] || @links
      @name  = result[:name] || name
      if @server.active_cache && @cache_name.nil?
        @cache_name = "#{@database.name}/#{@id}"
        @server.cache.save(:task, @cache_name, self)
      end
    end
    alias assign_attributes body=

    # === COMMANDS ===

    def retrieve
      result = @database.request("GET", "_api/view/#{@name}")
      return result.headers[:"x-arango-async-id"] if @server.async == :store
      return_element(result)
    end

    def manage_properties(method, url, consolidation_interval_msec: nil, threshold: nil, segment_threshold: nil, cleanup_interval_step: nil)
      body = {
        properties: {
          links: @links.empty? ? nil : @links,
          consolidationIntervalMsec: consolidation_interval_msec,
          consolidationPolicy: {
            threshold: threshold,
            segmentThreshold: segment_threshold
          },
          cleanupIntervalStep: cleanup_interval_step
        }
      }
      if method == "POST"
        body[:type] = @type
        body[:name] = @name
      end
      body[:properties][:consolidationPolicy].delete_if{|k,v| v.nil?}
      body[:properties].delete(:consolidationPolicy) if body[:properties][:consolidationPolicy].empty?
      body[:properties].delete_if{|k,v| v.nil?}
      body.delete(:properties) if body[:properties].empty?
      body.delete_if{|k,v| v.nil?}
      result = @database.request(method, url, body: body)
      return_element(result)
    end
    private :manage_properties

    def create(consolidation_interval_msec: nil, threshold: nil, segment_threshold: nil, cleanup_interval_step: nil)
      manage_properties("POST", "_api/view", consolidation_interval_msec: consolidation_interval_msec, threshold: threshold, segment_threshold: segment_threshold, cleanup_interval_step: cleanup_interval_step)
    end

    def replace_properties(consolidation_interval_msec: nil, threshold: nil, segment_threshold: nil, cleanup_interval_step: nil)
      manage_properties("PUT", "_api/view/#{@name}/properties", consolidation_interval_msec: consolidation_interval_msec, threshold: threshold, segment_threshold: segment_threshold, cleanup_interval_step: cleanup_interval_step)
    end

    def update_properties(consolidation_interval_msec: nil, threshold: nil, segment_threshold: nil, cleanup_interval_step: nil)
      manage_properties("PATCH", "_api/view/#{@name}/properties", consolidation_interval_msec: consolidation_interval_msec, threshold: threshold, segment_threshold: segment_threshold, cleanup_interval_step: cleanup_interval_step)
    end


    def properties
      @database.request("GET", "_api/view/#{@name}/properties")
    end


  end
end
