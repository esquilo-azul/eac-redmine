# frozen_string_literal: true

module EacFs
  module Executables
    class << self
      enable_simple_cache

      # @return [EacRubyUtils::Envs::Local]
      def env
        ::EacRubyUtils::Envs.local
      end

      private

      # @return [EacRubyUtils::Envs::Executable]
      def lsof_uncached
        env.executable('lsof', '-v')
      end
    end
  end
end
