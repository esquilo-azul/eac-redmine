# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      class Gemspec
        class Dependency
          enable_listable
          lists.add_string :type, '' => :common, '_development' => :development,
                                  '_runtime' => :runtime

          common_constructor :gemspec, :gem_name, :type do
            self.type = self.class.lists.type.value_validate!(type)
          end

          def version_specs=(version_specs)
            gemspec.add_or_replace_gem_line(gem_name, version_specs, type)
          end
        end
      end
    end
  end
end
