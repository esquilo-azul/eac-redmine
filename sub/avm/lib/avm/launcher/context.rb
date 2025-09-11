# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'

require 'eac_cli/speaker'

module Avm
  module Launcher
    class Context
      include ::EacRubyUtils::SimpleCache

      enable_speaker

      class << self
        attr_writer :current

        def current
          @current ||= default
        end

        def default
          @default ||= Context.new
        end
      end

      attr_reader :settings, :cache_root
      attr_accessor :publish_options, :recache, :instance_manager

      CONFIG_PATH_PREFIX = 'launcher'
      FS_OBJECT_ID = 'unique'

      def initialize(options = {})
        @options = options.with_indifferent_access
        @settings = ::Avm::Launcher::Context::Settings.new(build_option(:settings_file))
        @cache_root = build_option(:cache_root)
        @publish_options = { new: false, confirm: false, stereotype: nil }
        @instance_manager = ::Avm::Launcher::Context::InstanceManager.new(self)
        @recache = false
      end

      def fs_object_id
        FS_OBJECT_ID
      end

      def instance(name)
        instances.find { |i| i.name == name }
      end

      delegate :instances, to: :@instance_manager

      delegate :pending_instances, to: :@instance_manager

      private

      def build_option(key)
        @options[key] || config_option(key) || default_option(key)
      end

      def config_option(key)
        ::Avm::Self::Instance.default.entry([CONFIG_PATH_PREFIX, key].join('.')).optional_value
      end

      def default_cache_root
        fs_cache.path
      end

      def default_option(key)
        send("default_#{key}".underscore)
      end

      def default_settings_file
        ::File.join(::EacFs::Contexts.config.current.path, 'launcher.yaml')
      end

      def projects_uncached
        r = {}
        instances.each do |i|
          r[i.project_name] ||= []
          r[i.project_name] << i
        end
        r.map { |name, instances| ::Avm::Launcher::Project.new(name, instances) }
      end
    end
  end
end
