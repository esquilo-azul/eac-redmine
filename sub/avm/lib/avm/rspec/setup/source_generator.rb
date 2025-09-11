# frozen_string_literal: true

module Avm
  module Rspec
    module Setup
      module SourceGenerator
        DEFAULT_TARGET_BASENAME = 'generated_app'

        # @return [Avm::Sources::Base]
        def avm_source(stereotype_name, options = {})
          options = options.dup
          target_basename ||= options.delete(:target_basename) || DEFAULT_TARGET_BASENAME
          target_path ||= options.delete(:target_path) || temp_dir.join(target_basename)
          ::Avm::Registry.source_generators.detect(stereotype_name, target_path, options).perform
          ::Avm::Registry.sources.detect(target_path)
        end
      end
    end
  end
end
