# frozen_string_literal: true

RSpec.describe Avm::Launcher::Instances::Base do
  include_context 'with_launcher'
  let(:fixtures_dir) { __dir__.to_pathname.join('base_spec_files') }

  before do
    allow(ProgressBar).to receive(:create).and_return(double.as_null_object)
    context_set(fixtures_dir.join('settings.yaml').to_path, launcher_controller.dummy_directory)
    %w[avm-tools_stub ruby_gem_stub].each do |id|
      application_source_path(id, File.join(projects_root, id))
    end
  end

  include_examples 'with_config', __FILE__

  describe '#options' do
    context 'when instance is "avm-tools_stub"' do
      let(:instance) { Avm::Launcher::Context.current.instance('/avm-tools_stub') }

      it { expect(instance).to be_a(described_class) }
      it { expect(instance.options.git_current_revision).to eq('origin/master') }
      it { expect(instance.options.git_publish_remote).to eq('publish') }
      it { expect(instance.publishable?).to be(true) }
    end

    context 'when instance is "ruby_gem_stub"' do
      let(:instance) { Avm::Launcher::Context.current.instance('/ruby_gem_stub') }

      before do
        instance.application.entry('publishable').write(false)
      end

      it { expect(instance.options.git_current_revision).to eq('git_current_revision_setted') }
      it { expect(instance.options.git_publish_remote).to eq('git_publish_remote_setted') }
      it { expect(instance.publishable?).to be(false) }
    end
  end
end
