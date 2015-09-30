# encoding: UTF-8

require 'yaml'

module Trf1Sjap
  module TestHelpers
    module Files
      def assert_files_with_path
        sources_targets_basenames.each do |test_basename|
          assert_equal target_value(test_basename), yield(source_file(test_basename))
        end
      end

      private

      def target_value(basename)
        target_content_to_value(File.read(target_file(basename)))
      end

      def source_value(basename, &block)
        block.call(File.read(source_file(basename)))
      end

      def target_file(basename)
        fixture_file(basename, 'target')
      end

      def source_file(basename)
        fixture_file(basename, 'source')
      end

      def fixture_file(basename, suffix)
        prefix = "#{basename}.#{suffix}"
        Dir.foreach(fixtures_directory) do |item|
          next if item == '.' || item == '..'
          return File.expand_path(item, fixtures_directory) if item.starts_with?(prefix)
        end
        fail "\"#{prefix}\" não encontrado"
      end

      def target_content_to_value(file_content)
        YAML.load(file_content)
      end

      def sources_targets_basenames
        basenames = []
        Dir.foreach(fixtures_directory) do |item|
          next if item == '.' || item == '..'
          if /^(.+)\.(?:source|target)(?:\..+)?$/.match(File.basename(item))
            basenames << Regexp.last_match(1)
          end
        end
        fail "\"#{fixtures_directory}\" não possui nenhum arquivo para teste." if basenames.empty?
        basenames
      end

      def fixtures_directory
        @fixtures_directory ||= begin
          directory = files_directory
          fail "\"#{directory}\" não existe" unless File.exist?(directory)
          fail "\"#{directory}\" não é um diretório" unless File.directory?(directory)
          directory
        end
      end
    end
  end
end
