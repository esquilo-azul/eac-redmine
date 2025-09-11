# frozen_string_literal: true

RSpec.describe EacConfig::EntryPath do
  {
    'install.path' => {
      auto: 'auto_install_path',
      default: 'install_path_default_value',
      get: 'install_path',
      get_optional: 'install_path_optional',
      inherited_block: 'install_path_inherited_value_proc'
    }
  }.each do |instance_path, test_data|
    context "when path is \"#{instance_path}\"" do
      let(:instance) { described_class.assert(instance_path) }

      test_data.each do |method_prefix, expected_value|
        method_name = "#{method_prefix}_method_name"
        context "when method name is \"#{method_name}\"" do
          it do
            expect(instance.send(method_name)).to eq(expected_value.to_sym)
          end
        end
      end
    end
  end
end
