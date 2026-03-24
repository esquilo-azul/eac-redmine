# frozen_string_literal: true

require 'fileutils'

module EacFs
  class StorageTree
    CONTENT_FILE_NAME = '__content__'

    attr_reader :path

    def initialize(*path_parts)
      raise ArgumentError, "\"#{path_parts}\" is empty" if path_parts.empty?

      @path = ::File.expand_path(::File.join(*path_parts.map(&:to_s)))
    end

    def clear
      return unless stored?

      ::File.unlink(content_path)
    end

    def read
      return nil unless stored?

      ::File.read(content_path)
    end

    def read_or_store
      write(yield) unless stored?

      read
    end

    # @return [Object]
    def read_or_store_yaml(use_cache = true) # rubocop:disable Style/OptionalBooleanParameter
      write_yaml(yield) unless stored? && use_cache

      read_yaml
    end

    # @return [Object, nil]
    def read_yaml
      r = read
      r.nil? ? nil : ::EacRubyUtils::Yaml.load(r)
    end

    def write(value)
      assert_directory_on_path
      ::File.write(content_path, value)
      value
    end

    def write_yaml(object)
      write(::EacRubyUtils::Yaml.dump(object))
      object
    end

    def child(*child_path_parts)
      self.class.new(path, *child_path_parts)
    end

    def stored?
      ::File.exist?(content_path)
    end

    def content_path
      ::File.join(path, CONTENT_FILE_NAME)
    end

    private

    def assert_directory_on_path
      raise "#{path} is a file" if ::File.file?(path)

      ::FileUtils.mkdir_p(path)
    end
  end
end
