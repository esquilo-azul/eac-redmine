# frozen_string_literal: true

RSpec.describe Avm::Applications::Base do
  let(:instance) { described_class.new('avm-tools') }

  EacRubyUtils::Rspec
    .default_setup
    .stub_eac_config_node(self, File.join(__dir__, 'base_spec_fixture.yml'))

  describe '#id' do
    it { expect(instance.id).to eq('avm-tools') }
  end

  describe '#path_prefix' do
    it { expect(instance.path_prefix).to eq(['avm-tools']) }
  end

  describe '#read_entry' do
    it { expect(instance.read_entry(:exist)).to eq('exist') }
  end
end
