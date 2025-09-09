# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacActiveScaffold
  module Rspec
    class ControllerDirector
      enable_listable
      lists.add_symbol :option, :controller_class, :index_path, :model_class, :valid_data,
                       :valid_create_data, :valid_update_data
      common_constructor :example, :options do
        self.options = self.class.lists.option.hash_keys_validate!(options)
      end

      # @return [String]
      def attribute_label(attr)
        model_class.human_attribute_name(attr)
      end

      # @param example [RSpec::Core::ExampleGroup]
      # @param attrs [Hash]
      # @return [void]
      def attributes_set(example, attrs)
        attrs.each { |attr, value| attribute_set(example, attr, value) }
      end

      # @return [Boolean]
      def create?
        valid_create_data.present?
      end

      # @return [Class]
      def controller_class
        options[:controller_class] || example.described_class
      end

      # @return [String]
      def index_path
        options.fetch(OPTION_INDEX_PATH)
      end

      # @return [Class]
      def model_class
        options[OPTION_MODEL_CLASS] || controller_class.active_scaffold_config.model
      end

      # @return [String]
      def page_title
        model_class.model_name.human(count: 2)
      end

      # @return [Hash]
      def valid_create_data
        options[OPTION_VALID_CREATE_DATA] || valid_data
      end

      # @return [Hash]
      def valid_data
        options[OPTION_VALID_DATA]
      end

      # @return [Hash]
      def valid_update_data
        options[OPTION_VALID_UPDATE_DATA] || valid_data
      end

      require_sub __FILE__, require_mode: :kernel
    end
  end
end
