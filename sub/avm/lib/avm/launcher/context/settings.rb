# frozen_string_literal: true

require 'yaml'

module Avm
  module Launcher
    class Context
      class Settings
        include ::EacRubyUtils::SimpleCache

        def initialize(file)
          unless ::File.exist?(file)
            ::FileUtils.mkdir_p(::File.dirname(file))
            ::File.write(file, {}.to_yaml)
          end
          @data = YAML.load_file(file)
        end

        def instance_settings(instance)
          ::Avm::Launcher::Instances::Settings.new(value(['Instances', instance.name]))
        end

        private

        def excluded_projects_uncached
          enum_value(%w[Projects Exclude])
        end

        def excluded_paths_uncached
          enum_value(%w[Paths Exclude])
        end

        def enum_value(path)
          r = value(path)
          r.is_a?(Enumerable) ? r : []
        end

        def value(path)
          node_value(@data, path)
        end

        def node_value(data, path)
          return data if path.empty?
          return nil unless data.is_a?(Hash)

          node_value(data[path.first], path.drop(1))
        end
      end
    end
  end
end
