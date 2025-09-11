# frozen_string_literal: true

module Avm
  module Executables
    class << self
      include ::EacRubyUtils::SimpleCache

      def env
        ::EacRubyUtils::Envs.local
      end

      private

      %w[xdg-open].each do |program|
        define_method("#{program.underscore}_uncached") do
          env.executable(program, '--version')
        end
      end
    end
  end
end
