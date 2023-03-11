module Arango
  # Arango Database
  class Database
    # Arango Database FoxxServices
    # - not implemented -
    module FoxxServices
      # === FOXX ===
      def install_service
        # TODO
      end

      def replace_service
        # TODO
      end

      def upgrade_service
        # TODO
      end

      def uninstall_service
        # TODO
      end

      def list_services
        # TODO
      end

      def get_service
        # TODO
      end

      def get_service_configuration
        # TODO
      end

      def replace_service_configuration
        # TODO
      end

      def update_service_configuration
        # TODO
      end

      def get_service_dependencies
        # TODO
      end

      def replace_service_dependencies
        # TODO
      end

      def update_service_dependencies
        # TODO
      end

      def enable_service_development_mode
        # TODO
      end

      def disable_service_development_mode
        # TODO
      end

      def list_service_scripts
        # TODO
      end

      def run_service_script
        # TODO
      end

      def run_service_tests
        # TODO
      end

      def download_service
        # TODO
      end

      def get_service_readme
        # TODO
      end

      def get_service_documentation
        # TODO
      end

      def commit_local_Service_state
        # TODO
      end
      # def foxxes
      #   result = request("GET", "_api/foxx")
      #   return result if return_directly?(result)
      #   result.map do |fox|
      #     Arango::Foxx.new(database: self, mount: fox[:mount], body: fox)
      #   end
      # end

      # def foxx(body: {}, development: nil, legacy: nil, mount:, name: nil, provides: nil, setup: nil, teardown: nil, type: "application/json",
      #          version: nil)
      #   Arango::Foxx.new(body: body, database: self, development: development, legacy: legacy, mount: mount, name: name, provides: provides,
      #                    setup: setup, teardown: teardown, type: type, version: version)
      # end
    end
  end
end
