# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class Gemfile
        class Dependency
          common_constructor :gemfile, :gem_name

          def version_specs=(version_specs)
            gemfile.add_or_replace_gem_line(gem_name, version_specs)
          end
        end
      end
    end
  end
end
