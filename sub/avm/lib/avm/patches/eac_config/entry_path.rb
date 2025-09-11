# frozen_string_literal: true

require 'eac_config/entry_path'

module EacConfig
  class EntryPath
    # @return [Symbol]
    def auto_method_name
      method_name('auto_', '')
    end

    # @return [Symbol]
    def default_method_name
      method_name('', '_default_value')
    end

    # @return [Symbol]
    def get_method_name # rubocop:disable Naming/AccessorMethodName
      method_name('', '')
    end

    # @return [Symbol]
    def get_optional_method_name # rubocop:disable Naming/AccessorMethodName
      method_name('', '_optional')
    end

    # @return [Symbol]
    def inherited_block_method_name
      method_name('', '_inherited_value_proc')
    end

    # @return [String]
    def variableize
      parts.join('_')
    end

    private

    # @param before [String]
    # @param after [String]
    # @return [Symbol]
    def method_name(before, after)
      :"#{before}#{variableize}#{after}"
    end
  end
end
