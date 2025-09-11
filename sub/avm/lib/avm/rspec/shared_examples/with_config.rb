# frozen_string_literal: true

RSpec.shared_examples 'with_config' do |spec_file|
  config_path = spec_file.to_pathname
  config_path = config_path.dirname.join("#{config_path.basename_noext}_files", 'config.yml')
  temp_config_path = EacRubyUtils::Fs::Temp.file
  FileUtils.cp(config_path, temp_config_path)
  EacRubyUtils::Rspec.default_setup.stub_eac_config_node(self, temp_config_path)
end
