# frozen_string_literal: true

module Avm
  module Data
    class Dumper < ::Avm::Data::Performer
      DEFAULT_EXPIRE_TIME = 1.day
      DEFAULT_OVERWRITE = false
      DEFAULT_ROTATE = true

      enable_speaker
      enable_listable
      immutable_accessor :expire_time, :target_path
      immutable_accessor :overwrite, :rotate, type: :boolean

      # @return [nil]
      def cannot_perform_reason
        nil
      end

      # @return [Pathname]
      def default_dump_path
        r = data_owner.data_default_dump_path
        include_excludes_path_suffix.if_present(r) do |v|
          r.basename_sub('.*') { |b| "#{b}#{v}#{r.extname}" }
        end
      end

      # @return [Boolean]
      def target_path_expired?
        target_path_time.if_present(true) { |v| v >= expire_time }
      end

      # @return [ActiveSupport::Duration, nil]
      def target_path_time
        target_path.exist? ? ::Time.now - ::File.mtime(target_path) : nil
      end

      protected

      attr_reader :temp_data_path

      # @return [Array<Symbol>]
      def all_units
        data_owner.units.keys.sort
      end

      def build_temp_data_file
        data_owner.dump(temp_data_path, *include_excludes_arguments)
        raise "\"#{temp_data_path}\" do not exist" unless temp_data_path.exist?
        raise "\"#{temp_data_path}\" is not a file" unless temp_data_path.file?
      end

      # @return [String, nil]
      def do_rotate
        return unless target_path.exist?
        return unless rotate?

        infom "Rotating \"#{target_path}\"..."
        ::Avm::Data::Rotate.new(target_path).run
      end

      # @return [Array<Symbol>]
      def excluded_units
        excludes.map(&:to_sym).sort
      end

      # @return [ActiveSupport::Duration]
      def expire_time_get_filter(value)
        value || DEFAULT_EXPIRE_TIME
      end

      # @return [String]
      def include_excludes_path_suffix
        return nil unless data_owner.respond_to?(:units)

        r = included_units.any? ? included_units : all_units
        r -= excluded_units if excluded_units.any?
        r.any? && r != all_units ? "_#{r.join('-')}" : ''
      end

      # @return [Array<Symbol>]
      def included_units
        includes.map(&:to_sym).sort
      end

      # @return [self]
      def internal_perform
        use_current? ? internal_perform_use_current : internal_perform_new
      end

      def internal_perform_new
        on_temp_data_file do
          build_temp_data_file
          do_rotate
          move_data_to_target_path
        end
      end

      def internal_perform_use_current
        infom "Dump \"#{target_path}\" exists and is unexpired"
      end

      def move_data_to_target_path
        ::FileUtils.mv(temp_data_path, target_path.assert_parent)
      end

      def on_temp_data_file
        ::EacRubyUtils::Fs::Temp.on_file do |file|
          @temp_data_path = file.to_pathname
          yield
        end
      end

      # @return [Boolean]
      def overwrite_get_filter(value)
        value.nil? ? DEFAULT_OVERWRITE : value
      end

      def rotate_get_filter(value)
        value.nil? ? DEFAULT_ROTATE : value
      end

      # @return [Pathname]
      def target_path_get_filter(value)
        (value || default_dump_path).to_pathname
      end

      # @return [Boolean]
      def use_current?
        return false unless target_path.exist?
        return false if overwrite?

        !target_path_expired?
      end
    end
  end
end
