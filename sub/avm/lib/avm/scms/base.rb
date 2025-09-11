# frozen_string_literal: true

module Avm
  module Scms
    class Base
      require_sub __FILE__, include_modules: true
      enable_abstract_methods
      enable_simple_cache
      include ::Avm::With::ApplicationStereotype

      abstract_methods :update, :valid?
      common_constructor :path do
        self.path = path.to_pathname.expand_path
      end

      # @return [Avm::Scms::ChangedFile]
      def changed_files
        raise_abstract_method __method__
      end

      # @param options [Hash<Symbol, Object>]
      def completer(options = {}) # rubocop:disable Lint/UnusedMethodArgument
        raise_abstract_method __method__
      end

      # @return [Avm::Scms::Interval]
      def interval(_from, _to)
        raise_abstract_method __method__
      end

      def name
        self.class.name.demodulize
      end

      # @return [Pathname]
      def relative_path_from_parent_scm
        parent_scm.if_present(nil) do |v|
          path.relative_path_from(v.path)
        end
      end

      # @return [Enumerable<Avm::Scms::Base>]
      def subs
        raise_abstract_method __method__
      end

      def to_s
        name
      end

      private

      # @return [Avm::Scms::Base]
      def parent_scm_uncached
        ::Avm::Registry.scms.detect_by_path_optional(path.parent)
      end
    end
  end
end
