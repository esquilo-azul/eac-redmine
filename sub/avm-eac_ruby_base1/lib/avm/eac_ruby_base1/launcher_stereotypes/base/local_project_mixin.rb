# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        module LocalProjectMixin
          # @return [Avm::EacRubyBase1::Sources::Base]
          def ruby_gem
            @ruby_gem ||= ::Avm::EacRubyBase1::Sources::Base.new(path)
          end

          def version
            ruby_gem.version.if_present { |v| ::Avm::VersionNumber.new(v) }
          end

          def version=(value)
            ruby_gem.version_file.value = value
          end
        end
      end
    end
  end
end
