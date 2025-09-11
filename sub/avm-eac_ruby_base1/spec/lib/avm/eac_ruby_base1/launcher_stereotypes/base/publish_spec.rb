# frozen_string_literal: true

RSpec.describe Avm::EacRubyBase1::LauncherStereotypes::Base::Publish do
  let(:context) { temp_launcher_context }
  let(:application_id) { 'ruby_gem_stub' }
  let(:source_path) { temp_dir.join(application_id) }

  before do
    EacConfig::Node.context.current.entry("#{application_id}.avm_type").value = 'Application'
    EacConfig::Node.context.current.entry("#{application_id}_dev.install.path").value =
      source_path.to_path
    avm_eac_ruby_base1_source(target_path: source_path)
  end

  describe '#publish' do
    let(:instance) { context.instance('/ruby_gem_stub') }

    it 'dries run publish for Ruby Gems' do
      allow_any_instance_of(described_class).to receive(:gem_versions_uncached).and_return([]) # rubocop:disable RSpec/AnyInstance
      expect(instance).to be_a Avm::Launcher::Instances::Base
      context.publish_options = { confirm: false, new: true, stereotype: 'RubyGem' }
      described_class.new(instance).run
    end
  end
end
