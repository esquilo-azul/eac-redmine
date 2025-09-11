# frozen_string_literal: true

RSpec.describe Avm::EacRubyBase1::LauncherStereotypes::Base do
  describe '#load_gemspec' do
    let(:dummy_dir) { avm_eac_ruby_base1_source(target_path: temp_dir.join(gemname)).path }
    let(:gemname) { 'avm-eac_ruby_base1' }
    let(:self_gemspec) { File.join(app_root_path, "#{gemname}.gemspec") }
    let(:stub_gemspec) { File.join(dummy_dir, "#{gemname}.gemspec") }
    let(:stub_expected_version) { '0.0.0' }

    it 'does not return same version for different gemspecs with same name' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      stub_spec = described_class.load_gemspec(stub_gemspec)
      expect(stub_spec.version).to eq(stub_expected_version)
      expect(stub_spec.name).to eq(gemname)

      self_spec = described_class.load_gemspec(self_gemspec)
      expect(self_spec.version).not_to eq(stub_expected_version)
      expect(self_spec.name).to eq(gemname)
    end
  end
end
