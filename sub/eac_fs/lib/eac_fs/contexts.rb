# frozen_string_literal: true

module EacFs
  class Contexts
    TYPES = %i[cache config data].freeze

    class << self
      TYPES.each do |type|
        class_eval <<~CODE, __FILE__, __LINE__ + 1
          # @return [EacRubyUtils::Context<EacFs::StorageTree>]
          def #{type}                                 # def cache
            @#{type} ||= ::EacRubyUtils::Context.new  #   @cache ||= ::EacRubyUtils::Context.new
          end                                         # end
        CODE
      end
    end
  end
end
