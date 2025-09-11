# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class GemfileLocal
        class Sibling
          common_constructor :gemfile_local, :source
          delegate :relative_path, to: :source

          # @return [String]
          def gemspec_relative_path
            source.gemspec_path.relative_path_from(gemfile_local.source.path).to_path
          end

          # @return [String]
          def root_relative_path
            source.path.relative_path_from(gemfile_local.source.path).to_path
          end

          # @return [String]
          def target_content
            "gem '#{source.gem_name}', #{gem_options_content} if #{condition_content}\n"
          end

          protected

          # @return [String]
          def condition_content
            "::File.file?(::File.expand_path('#{gemspec_relative_path}', __dir__))"
          end

          # @return [String]
          def gem_option_path
            ["::File.expand_path('", root_relative_path, "', __dir__)"].join
          end

          # @return [String]
          def gem_option_require
            'false'
          end

          # @return [String]
          def gem_options_content
            %w[path require].map { |v| [v, send("gem_option_#{v}")].join(': ') }.join(', ')
          end
        end
      end
    end
  end
end
