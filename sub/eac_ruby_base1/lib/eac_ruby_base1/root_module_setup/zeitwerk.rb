# frozen_string_literal: true

module EacRubyBase1
  class RootModuleSetup
    module Zeitwerk
      # @return [Zeitwerk::GemLoader]
      def loader
        @loader ||= ::Zeitwerk::Registry.loader_for_gem(
          root_module_file,
          namespace: namespace,
          warn_on_extra_files: true
        )
      end

      # @param enable [Boolean] `true` to enable, `false` (default) to disable.
      # @return
      def logging(enable)
        @logging = enable
      end

      # @return [Boolean]
      def logging?
        @logging ? true : false
      end

      protected

      # @return [void]
      def perform_zeitwerk
        loader.log! if logging?
        loader.setup
      end
    end
  end
end
