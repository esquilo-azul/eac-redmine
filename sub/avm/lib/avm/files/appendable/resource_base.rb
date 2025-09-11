# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Files
    module Appendable
      class ResourceBase
        acts_as_abstract :to_s_attributes
        common_constructor :appender

        def to_s
          v_to_s = to_s_attributes.map { |k| "#{k}: #{send(k)}" }.join(', ')
          "#{self.class.name}[#{v_to_s}]"
        end
      end
    end
  end
end
