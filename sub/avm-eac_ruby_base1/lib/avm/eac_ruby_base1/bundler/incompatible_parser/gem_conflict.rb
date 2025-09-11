# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class IncompatibleParser
        class GemConflict < ::Avm::EacRubyBase1::Bundler::IncompatibleParser::LineParserBase
          LINE_PARSER = /Bundler could not find compatible versions for gem "(.+)":/
                          .to_parser { |m| new(m[1]) }

          enable_simple_cache
          common_constructor :gem_name

          def add_depends_on(depends_on)
            depends_on_stack << depends_on
          end

          def add_version_requirement(version_requirement)
            version_requirement.stack = depends_on_stack
            versions_requirements << version_requirement
            @depends_on_stack = nil
          end

          def data
            { gem_name: gem_name, versions_requirements: versions_requirements.map(&:data) }
          end

          def versions_requirements
            @versions_requirements ||= []
          end

          private

          def depends_on_stack
            @depends_on_stack ||= []
          end
        end
      end
    end
  end
end
