# encoding: UTF-8

require 'yaml'

module FileTestHelper
  def test_parser
    test_basenames.each do |test_basename|
      assert_equal target_value(test_basename), source_value(test_basename)
    end
  end

  def target_value(basename)
    target_content_to_value(File.read(target_file(basename)))
  end

  def source_value(basename)
    source_content_to_value(File.read(source_file(basename)))
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
      next if item == '.' or item == '..'
      return File.expand_path(item, fixtures_directory) if item.starts_with?(prefix)
    end
    fail "\"#{prefix}\" não encontrado"
  end

  protected

  def target_content_to_value(file_content)
    YAML.load(file_content)
  end

  def source_content_to_value(_file_content)
    fail 'Método "source_content_to_value" deve ser sobreescrito'
  end

  private

  def test_basenames
    basenames = []
    Dir.foreach(fixtures_directory) do |item|
      next if item == '.' or item == '..'
      if /^(.+)\.(?:source|target)(?:\..+)?$/.match(File.basename(item))
        basenames << Regexp.last_match(1)
      end
    end
    fail "\"#{fixtures_directory}\" não possui nenhum arquivo para teste." if basenames.empty?
    basenames
  end

  def fixtures_directory
    @fixtures_directory ||= begin
      directory = File.expand_path('fixtures/' + ActiveSupport::Inflector.underscore(self.class.to_s) + '_files', File.dirname(__FILE__))
      fail "\"directory\" não existe" unless File.exist?(directory)
      fail "\"directory\" não é um diretório" unless File.directory?(directory)
      directory
    end
  end
end
