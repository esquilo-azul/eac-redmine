# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        class Publish < ::Avm::Launcher::Publish::Base
          module LocalGem
            protected

            def gem_build_uncached
              ::Avm::EacRubyBase1::Launcher::Gem::Build.new(source)
            end

            def gem_spec_uncached
              ::Avm::EacRubyBase1::LauncherStereotypes::Base.load_gemspec(gemspec)
            end

            def gemspec_uncached
              source.find_file_with_extension('.gemspec')
            end

            def source_uncached
              instance.warped
            end
          end
        end
      end
    end
  end
end
