# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

require 'eac_templates/variables/directory'

module Avm
  module Files
    module Appendable
      class TemplatizedDirectory < ::Avm::Files::Appendable::ResourceBase
        common_constructor :appender, :source_path, super_args: -> { [appender] }

        # @return [Object]
        def applier
          return source_path if source_path.respond_to?(:apply)

          applier_from_path
        end

        # @return [EacTemplates::Variables::Directory]
        def applier_from_path
          raise "\"#{source_path}\" is not a directory" unless ::File.directory?(source_path)

          ::EacTemplates::Variables::Directory.new(source_path)
        end

        def write_on(target_dir)
          raise 'Variables source not set' if appender.variables_source.blank?

          applier.apply(appender.variables_source, target_dir)
        end

        # @return [Enumerable<Symbol>]
        def to_s_attributes
          [:source_path]
        end
      end
    end
  end
end
