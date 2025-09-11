# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        require_sub __FILE__
        include ::Avm::Launcher::Stereotype

        STEREOTYPE_NAME = 'EacRubyBase1'

        class << self
          def match?(path)
            Dir.glob(File.join(path.real, '*.gemspec')).any?
          end

          def color
            :red
          end

          def load_gemspec(gemspec_file)
            ::Avm::EacRubyBase1::Launcher::Gem::Specification.new(gemspec_file)
          end

          # @return [String]
          def stereotype_name
            STEREOTYPE_NAME
          end
        end
      end
    end
  end
end
