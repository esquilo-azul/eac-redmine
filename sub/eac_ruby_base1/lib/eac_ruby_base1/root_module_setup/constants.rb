# frozen_string_literal: true

module EacRubyBase1
  class RootModuleSetup
    module Constants
      # @return [Module, nil]
      def extension_for
        dirname = ::File.dirname(relative_root_module_file)
        return nil if ['.', '/', ''].include?(dirname)

        require dirname
        resolve_or_create_module(::Pathname.new(dirname))
      end

      # @return [Module]
      def namespace
        extension_for || DEFAULT_NAMESPACE
      end

      # @return [Module]
      def root_module
        resolve_or_create_module(relative_root_module_file)
      end

      protected

      # @param relative_path [Pathname]
      # @return [Module]
      def resolve_or_create_module(relative_path)
        relative_path.each_filename.inject(DEFAULT_NAMESPACE) do |a, e|
          const_name = e.camelize
          a.const_set(const_name, ::Module.new) unless a.const_defined?(const_name, false)
          a.const_get(const_name)
        end
      end
    end
  end
end
