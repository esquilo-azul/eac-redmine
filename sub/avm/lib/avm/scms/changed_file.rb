# frozen_string_literal: true

module Avm
  module Scms
    class ChangedFile
      enable_abstract_methods
      enable_listable
      lists.add_symbol :action, :add, :delete, :modify

      # @return [Pathname]
      def absolute_path
        path.expand_path(scm.path)
      end

      # @return [Symbol]
      def action
        raise_abstract_method __method__
      end

      # @return [Boolean]
      def add?
        action == ACTION_ADD
      end

      # @return [Boolean]
      def delete?
        action == ACTION_DELETE
      end

      # @return [Boolean]
      def modify?
        action == ACTION_MODIFY
      end

      # @return [Pathname]
      def path
        raise_abstract_method __method__
      end

      # @return [Avm::Scms::Base]
      def scm
        raise_abstract_method __method__
      end
    end
  end
end
