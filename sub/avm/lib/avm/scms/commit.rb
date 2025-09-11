# frozen_string_literal: true

module Avm
  module Scms
    class Commit
      enable_abstract_methods

      # @return [Array<Pathname>]
      def changed_files
        raise_abstract_method __method__
      end

      def deploy_to_env_path(_target_env, _target_path)
        raise_abstract_method __method__
      end

      # @return [Boolean]
      def fixup?
        raise_abstract_method __method__
      end

      def id
        raise_abstract_method __method__
      end

      # @param other [Avm::Scms::Commit]
      # @return [Avm::Scms::Commit]
      def merge_with(_other)
        raise_abstract_method __method__
      end

      # @return [Array<Pathname>]
      def no_scm_changed_files
        changed_files.reject { |path| scm_file?(path) }
      end

      # @param new_message [String]
      def reword(_new_message)
        raise_abstract_method __method__
      end

      # @return [Array<Pathname>]
      def scm_changed_files
        changed_files.select { |path| scm_file?(path) }
      end

      # @param path [Pathname]
      # @return [TrueClass,FalseClass]
      def scm_file?(_path)
        raise_abstract_method __method__
      end

      # @return [String]
      def subject
        raise_abstract_method __method__
      end

      # @return [String]
      def to_s
        "#{subject} [#{id}]"
      end
    end
  end
end
