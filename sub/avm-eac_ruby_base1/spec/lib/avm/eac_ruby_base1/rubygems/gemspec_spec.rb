# frozen_string_literal: true

RSpec.describe Avm::EacRubyBase1::Rubygems::Gemspec do
  let(:gemspec_path) { fixtures_directory.join('the_gem.gemspec') }

  include_examples 'source_target_fixtures', __FILE__

  # @return [Avm::EacRubyBase1::Rubygems::Gemspec]
  def new_gemspec
    described_class.from_file(gemspec_path)
  end

  # @return [String]
  def source_data(file)
    EacRubyUtils::Yaml.load_file(file).each_with_object(new_gemspec) do |e, a|
      a.dependency(e.fetch(0)).version_specs = e.fetch(1)
    end.to_text
  end

  # @return [String]
  def target_data(target_file)
    target_file.to_pathname.read
  end

  # @param data [String]
  # @return [String]
  def target_content(data)
    data
  end

  # @return [String]
  def target_file_extname
    '.txt'
  end
end
