module Arango
  # Arango Server
  class Server
    # Arango Server OpalSupport
    module OpalSupport
      # From the Arango 2.8 documentation:
      #
      # Modules Path versus Modules Collection
      #
      # ArangoDB comes with predefined modules defined in the file-system under the path specified by
      # startup.startup-directory. In a standard installation this point to the system share directory.
      # Even if you are an administrator of ArangoDB you might not have write permissions to this location.
      # On the other hand, in order to deploy some extension for ArangoDB, you might need to install additional
      # JavaScript modules. This would require you to become root and copy the files into the share directory.
      # In order to ease the deployment of extensions, ArangoDB uses a second mechanism to look up JavaScript modules.
      #
      # JavaScript modules can either be stored in the filesystem as regular file or
      # in the database collection _modules.
      #
      # If you execute
      #
      # require("com/example/extension")
      #
      # then ArangoDB will try to locate the corresponding JavaScript as file as follows
      #
      #     There is a cache for the results of previous require calls. First of all ArangoDB checks if
      #     com/example/extension is already in the modules cache. If it is, the export object for this module
      #     is returned. No further JavaScript is executed.
      #
      #     ArangoDB will then check, if there is a file called com/example/extension.js in the system search path.
      #     If such a file exists, it is executed in a new module context and the value of exports object is returned.
      #     This value is also stored in the module cache.
      #
      #     If no file can be found, ArangoDB will check if the collection _modules contains a document of the form
      #
      # {
      #   path: "/com/example/extension",
      #   content: "...."
      # }
      #
      # Note: The leading / is important - even if you call require without a leading /. If such a document exists,
      # then the value of the content attribute must contain the JavaScript code of the module. This string is
      # executed in a new module context and the value of exports object is returned. This value is also stored
      # in the module cache.
      #
      #
      # Taken from the Changelog for 3.5.0.rc.1,
      # https://github.com/arangodb/arangodb/blob/43fa37e35935e095dae31f250456f030da3c451f/CHANGELOG#L826:
      #
      # * Do not create `_modules` collection for new databases/installations.
      #
      #   `_modules` is only needed for custom modules, and in case a custom
      #   module is defined via `defineModule`, the _modules collection will
      #   be created lazily automatically.
      #
      #   Existing modules in existing `_modules` collections will remain
      #   functional even after this change
      #
      #
      #  So this is what we use for storing the opal module in arango and making it available.

      def install_opal_module(database = '_system', force: false)
        database = database.name unless database.class == String
        dirname = File.dirname(__FILE__)
        filename = File.expand_path(File.join(dirname, '..', '..', '..', 'arango_opal.js'))
        content = File.read(filename)
        system_db = get_database(name: database)
        system_db.create_collection(name: '_modules', is_system: true) unless system_db.collection_exists?(name: '_modules', exclude_system: false)
        modules_collection = system_db.get_collection(name: '_modules')
        opal_module_doc = modules_collection.get_document(attributes: { path: '/opal' })
        if opal_module_doc
          opal_module_doc.content = content
          opal_module_doc.update
        else
          modules_collection.create_document(attributes: { path: '/opal', content: content })
        end
      end

      # def install_opal_parser_module(database = '_system', force: false)
      #   database = database.name unless database.class == String
      #   dirname = File.dirname(__FILE__)
      #   filename = File.expand_path(File.join(dirname, '..', '..', '..', 'arango_opal_parser.js'))
      #   content = File.read(filename)
      #   system_db = get_database(database)
      #   system_db.create_collection('_modules', is_system: true) unless system_db.collection_exists?('_modules', exclude_system: false)
      #   modules_collection = system_db.get_collection('_modules')
      #   opal_module_doc = modules_collection.get_document(path: '/opal-parser')
      #   if opal_module_doc
      #     opal_module_doc.content = content
      #     opal_module_doc.update
      #   else
      #     modules_collection.create_document({ path: '/opal-parser', content: content })
      #   end
      # end
    end
  end
end
