# frozen_string_literal: true

module Avm
  module Sources
    class Base
      require_sub __FILE__, include_modules: true
      include ::Avm::With::ApplicationStereotype
      include ::Avm::With::ExtraSubcommands

      compare_by :path
      enable_abstract_methods
      enable_simple_cache
      enable_listable
      lists.add_symbol :option, :parent
      common_constructor :path, :options, default: [{}] do
        self.path = path.to_pathname.expand_path
        self.options = ::Avm::Sources::Base.lists.option.hash_keys_validate!(options)
      end

      abstract_methods :valid?

      # @param options [Hash<Symbol, Object>]
      def completer(options = {})
        scm.completer(options)
      end

      # @return [EacRubyUtils::Envs::LocalEnv]
      def env
        ::EacRubyUtils::Envs::LocalEnv.new
      end

      # @return [Pathname]
      def relative_path
        return path if parent.blank?

        path.relative_path_from(parent.path)
      end

      def to_s
        "#{self.class}[#{path}]"
      end

      # @return [Avm::VersionNumber, nil]
      def version
        raise_abstract __method__, 'Should return a Avm::VersionNumber or nil'
      end

      private

      # @return [Avm::Scms::Base]
      def scm_uncached
        ::Avm::Registry.scms.detect_optional(path) || ::Avm::Scms::Null.new(path)
      end
    end
  end
end
