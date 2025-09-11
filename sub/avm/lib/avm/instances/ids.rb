# frozen_string_literal: true

module Avm
  module Instances
    module Ids
      ID_PARTS_SEPARATOR = '_'
      ID_PATTERN = /\A([a-z0-9]+(?:-[a-z0-9]+)*)_(.+)\z/.freeze
      ID_PARSER = ID_PATTERN.to_parser do |m|
        ::Struct.new(:application_id, :instance_suffix).new(m[1], m[2])
      end

      class << self
        # @param application_id [String]
        # @param instance_suffix [String]
        # @return [String]
        def build(application_id, instance_suffix)
          [application_id, instance_suffix].join(ID_PARTS_SEPARATOR)
        end

        # @param id [String]
        # @return [String]
        def parse!(id) # rubocop:disable Rails/Delegate
          ID_PARSER.parse!(id)
        end
      end
    end
  end
end
