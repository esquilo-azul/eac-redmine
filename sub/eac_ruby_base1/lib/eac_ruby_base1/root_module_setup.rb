# frozen_string_literal: true

require 'active_support/inflector'
require 'eac_ruby_utils/patches/module/require_sub'
require 'zeitwerk'

module EacRubyBase1
  class RootModuleSetup
    require_sub __FILE__, require_mode: :kernel, include_modules: true

    DEFAULT_NAMESPACE = ::Object
    LIB_DIRECTORY_BASENAME = 'lib'

    class << self
      # @param root_module_file [Pathname]
      def perform(root_module_file, &)
        new(root_module_file, &).perform
      end
    end

    attr_reader :block
    attr_writer :logging

    # @param root_module_file [Pathname]
    def initialize(root_module_file, &block)
      self.root_module_file = root_module_file.to_pathname
      self.block = block
    end

    # @return [void]
    def perform
      perform_block
      perform_zeitwerk
      root_module
      perform_requires
      require_patches
    end

    protected

    attr_writer :block

    def perform_block
      instance_eval(&block) if block
    end
  end
end
