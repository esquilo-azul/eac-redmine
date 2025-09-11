# frozen_string_literal: true

RSpec.describe Avm::EacRubyBase1::Rubygems::VersionFile do
  include_context 'spec_paths', __FILE__

  let(:stub_file) { fixtures_directory.join('a_version_file.rb') }
  let(:instance) { described_class.new(stub_file) }
  let(:target_version) { Gem::Version.new('0.69.1') }

  describe '#value' do
    it { expect(instance.value).to eq(target_version) }
  end
end
