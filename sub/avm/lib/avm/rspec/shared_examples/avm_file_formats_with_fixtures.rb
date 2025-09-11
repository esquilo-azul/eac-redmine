# frozen_string_literal: true

RSpec.shared_examples 'avm_file_formats_with_fixtures' do |the_spec_file|
  include_examples 'source_target_fixtures', the_spec_file

  def format_files_in_directory(target_dir)
    Avm::FileFormats::SearchFormatter
      .new([target_dir], recursive: true, apply: true, verbose: false)
      .run
  end

  def source_data(source_file)
    dir = temp_dir
    source_basename = source_file_basename_without_source_extname(source_file)
    source_path = dir.join(source_basename)
    FileUtils.cp(source_file, source_path)
    format_files_in_directory(dir)
    source_path.read
  end

  def source_file_basename_without_source_extname(source_file)
    source_file.to_pathname.basename_sub { |b| b.to_path.gsub('.source', '') }.basename
  end

  def target_data(target_file)
    File.read(target_file)
  end
end
