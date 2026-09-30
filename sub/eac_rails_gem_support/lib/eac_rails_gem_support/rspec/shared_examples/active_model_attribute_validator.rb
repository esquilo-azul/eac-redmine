# frozen_string_literal: true

RSpec.shared_examples 'active_model_attribute_validator' do |valid_values, invalid_values| # rubocop:disable Metrics/BlockLength
  let(:model) do
    validator = described_class.name.gsub(/Validator\z/, '').underscore
    Class.new do
      include ActiveModel::Model

      attr_accessor :the_attribute

      validates :the_attribute, validator => true, allow_nil: true
    end
  end
  let(:record) { model.new }

  { true => valid_values, false => invalid_values }.each do |valid, values|
    values.each do |value|
      context "when the_attribute is \"#{value}\"" do
        before do
          record.the_attribute = value
          record.valid?
        end

        if valid
          it { expect(record).to be_valid }
          it { expect(record.errors[:the_attribute]).to eq([]) }
        else
          it { expect(record).not_to be_valid }
          it { expect(record.errors[:the_attribute]).not_to eq([]) }
        end
      end
    end
  end
end
