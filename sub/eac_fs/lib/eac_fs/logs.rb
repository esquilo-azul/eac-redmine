# frozen_string_literal: true

require 'filesize'

module EacFs
  class Logs
    require_sub __FILE__

    # @param label [Symbol]
    # @return [EacRubyUtils::Fs::Temp::File]
    def [](label)
      log_set.fetch(sanitize_label(label)).file
    end

    # @param label [Symbol]
    # @return [EacFs::Logs]
    def add(label)
      file = ::EacFs::Logs::File.new(sanitize_label(label))
      log_set[file.label] = file

      self
    end

    # @return [EacFs::Logs]
    def clean_all
      log_set.each_value(&:clean)
    end

    # @return [EacFs::Logs]
    def remove_all
      log_set.each_key { |label| remove(label) }

      self
    end

    # @param label [Symbol]
    def remove(label)
      log_set.fetch(sanitize_label(label)).remove
      log_set.delete(sanitize_label(label))
    end

    # @param length [Integer]
    # @return [String]
    def truncate_all(length = ::EacFs::Logs::File::TRUNCATE_DEFAULT_LENGTH)
      "Files: #{log_set.length}\n" +
        log_set.values.map { |file| file.truncate_with_label(length) }.join
    end

    private

    # @param label [Object]
    # @return [Symbol]
    def sanitize_label(label)
      label.to_sym
    end

    # @return [Hash<Symbol, EacFs::Logs::File>]
    def log_set
      @log_set ||= {}
    end
  end
end
