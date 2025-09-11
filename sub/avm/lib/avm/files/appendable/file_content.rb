# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Files
    module Appendable
      class FileContent < ::Avm::Files::Appendable::ResourceBase
        attr_reader :target_path, :content

        def initialize(deploy, target_path, content)
          super(deploy)
          @target_path = target_path
          @content = content
        end

        def write_on(target_dir)
          target_dir.join(target_path).write(content)
        end

        protected

        # @return [Enumerable<Symbol>]
        def to_s_attributes
          %i[target_path content]
        end
      end
    end
  end
end
