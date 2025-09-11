# frozen_string_literal: true

module Avm
  module Instances
    class Base
      enable_abstract_methods
      enable_listable
      enable_simple_cache
      include ::Avm::Entries::Base

      require_sub __FILE__, include_modules: true
      include ::Avm::With::ExtraSubcommands
      include ::Avm::With::ApplicationStereotype

      lists.add_string :access, :local, :ssh

      ID_PATTERN = /\A([a-z0-9]+(?:-[a-z0-9]+)*)_(.+)\z/.freeze

      class << self
        def by_id(id)
          parsed_id = ::Avm::Instances::Ids.parse!(id)

          new(::Avm::Applications::Base.new(parsed_id.application_id), parsed_id.instance_suffix)
        end
      end

      common_constructor :application, :suffix do
        self.suffix = suffix.to_s
      end

      # @return [Avm::Instances::Data::Package]
      def data_package
        @data_package ||= data_package_create
      end

      # @return [Avm::Instances::Data::Package]
      def data_package_create
        ::Avm::Instances::Data::Package.new(self)
      end

      # @return [String]
      def id
        ::Avm::Instances::Ids.build(application.id, suffix)
      end

      def to_s
        id
      end

      def host_env_uncached
        case install_scheme
        when 'file' then ::EacRubyUtils::Envs.local
        when 'ssh' then ::EacRubyUtils::Envs.ssh(install_url)
        else raise("Unmapped access value: \"#{install_scheme}\"")
        end
      end

      # @return [Boolean]
      def local?
        suffix == ::Avm::Applications::Base::LocalInstance::LOCAL_INSTANCE_SUFFIX
      end

      private

      def source_instance_uncached
        ::Avm::Instances::Base.by_id(source_instance_id)
      end
    end
  end
end
