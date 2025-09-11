# frozen_string_literal: true

require 'eac_config/entry_path'

module Avm
  module Sources
    class Base
      module Application
        APPLICATION_NAME_KEY = 'application'

        # @return [Avm::Applications::Base]
        def application
          @application ||= ::Avm::Applications::Base.new(application_id)
        end

        # @return [String]
        def application_id
          application_id_by_configuration || application_id_by_directory
        end

        # @return [String, nil]
        def application_id_by_configuration
          configuration.entry(APPLICATION_NAME_KEY).value
        end

        # @return [String]
        def application_id_by_directory
          path.basename.to_path.gsub(::EacConfig::EntryPath::PART_SEPARATOR, '-')
            .gsub(/\A-+/, '').gsub(/-+\z/, '')
        end
      end
    end
  end
end
