# frozen_string_literal: true

RSpec.describe Avm::EacRubyBase1::PreferredVersionRequirements do
  describe '#to_requirements_list' do
    {
      '0.1.0' => ['~> 0.1'],
      '0.1.1' => ['~> 0.1', '>= 0.1.1'],
      '0.5' => ['~> 0.5'],
      '4.2.11.3' => ['~> 4.2.11', '>= 4.2.11.3'],
      '1' => ['~> 1.0']
    }.each do |source, expected|
      context "when version is \"#{source}\"" do
        subject(:instance) { described_class.new(source) }

        it do
          expect(instance.to_requirements_list).to eq(expected)
        end
      end
    end
  end
end
