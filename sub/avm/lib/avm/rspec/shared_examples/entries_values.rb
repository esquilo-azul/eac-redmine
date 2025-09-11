# frozen_string_literal: true

RSpec.shared_examples 'entries_values' do |spec_file, expected_values|
  describe '#read_entry' do
    include_examples 'with_config', spec_file

    expected_values.each do |instance_id, values|
      values.each do |input, expected|
        context "when a auto value is requested for \"#{instance_id}.#{input}\"" do
          let(:instance) { described_class.by_id(instance_id) }

          it ".entry('#{input}').value should return \"#{expected}\"" do
            expect(instance.entry(input).value).to eq(expected)
          end
        end
      end
    end
  end
end
