# frozen_string_literal: true

RSpec.shared_examples 'in_avm_registry' do |registry_method|
  let(:avm_registry) { Avm::Registry.send(registry_method) }

  it 'is in the avm registry' do
    expect(avm_registry.registered_modules).to include(described_class)
  end
end
