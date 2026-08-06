# frozen_string_literal: true

module EacFs
  module Traversable
    PROP_METHOD_PREFIX = 'traverser_'
    BOOLEAN_PROPS = %i[hidden_directories recursive sort].freeze
    PATH_PROPS = %i[check_directory check_file].freeze

    class << self
      def prop_method_name(prop)
        "#{PROP_METHOD_PREFIX}#{prop}"
      end
    end

    PATH_PROPS.each do |method|
      define_method(::EacFs::Traversable.prop_method_name(method)) do |_path|
        nil
      end
    end

    BOOLEAN_PROPS.each do |method|
      define_method(::EacFs::Traversable.prop_method_name(method)) do
        false
      end

      define_method("#{::EacFs::Traversable.prop_method_name(method)}?") do
        send(method_name)
      end
    end

    def traverser_check_path(path)
      traverser_new.check_path(path)
    end

    def traverser_new
      r = ::EacFs::Traverser.new
      (BOOLEAN_PROPS + PATH_PROPS).each do |prop|
        r.send("#{prop}=", method(::EacFs::Traversable.prop_method_name(prop)))
      end
      r
    end
  end
end
