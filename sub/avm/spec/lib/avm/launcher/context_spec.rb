# frozen_string_literal: true

RSpec.describe Avm::Launcher::Context do
  include_context 'with_launcher'
  include_examples 'with_config', __FILE__

  describe '#instances' do
    before do
      %w[avm-tools_stub ruby_gem_stub].each do |id|
        application_source_path(id, launcher_controller.dummy_directory.join(id))
      end
    end

    it 'returns all stub instances' do
      is = described_class.current.instances.map(&:name)
      expect(is).to contain_exactly('/avm-tools_stub', '/ruby_gem_stub')
    end
  end

  describe '#instance' do
    it 'returns with slash on begin' do
      expect(described_class.current.instance('/avm-tools_stub'))
        .to be_a(Avm::Launcher::Instances::Base)
    end

    context 'when the subinstance is mylib' do
      let(:mylib_repos) do
        r = init_remote('mylib_repos')
        wc = init_git('mylib_wc')
        touch_commit(wc, 'app.gemspec')
        wc.execute!('remote', 'add', 'origin', r)
        wc.execute!('push', 'origin', 'master')
        r
      end

      before do
        temp_context(File.join(__dir__, 'context_spec.yml'))
        mylib_repos
        application_source_path('app', File.join(projects_root, 'app'))
      end

      context 'when sub is a GitSubrepo' do
        let(:sub) { described_class.current.instance('/app/sub1') }
        let(:instance) { described_class.current.instance('/app/sub1/mylib') }

        before do
          app = init_git('app')
          touch_commit(app, 'sub1/app.gemspec')
          app.execute!('subrepo', 'clone', mylib_repos, 'sub1/mylib')
        end

        it { expect(sub).to be_a(Avm::Launcher::Instances::Base) }

        it do
          Avm::Launcher::Stereotype.git_stereotypes
            .each { |s| expect(sub.stereotypes).not_to include(s) }
        end

        it { expect(instance).to be_a(Avm::Launcher::Instances::Base) }
        it { expect(instance.stereotypes).to include(Avm::Git::LauncherStereotypes::GitSubrepo) }
      end

      context 'when subinstance in HEAD and not in git_current_revision' do
        it 'does not return subinstance' do
          app = init_git('app') # HEAD: master
          touch_commit(app, 'file2')
          app.execute!('checkout', '-b', 'not_master') # HEAD: not_master
          app.execute!('subrepo', 'clone', mylib_repos, 'mylib')
          expect(described_class.current.instance('/app/mylib')).to be_nil
        end
      end

      context 'when subinstances in/not in HEAD and not in/in git_current_revision' do
        context 'when subinstance in HEAD and not in git_current_revision' do
          it 'does not return subinstance' do
            app = init_git('app') # HEAD: master
            touch_commit(app, 'file2')
            app.execute!('checkout', '-b', 'not_master') # HEAD: not_master
            app.execute!('subrepo', 'clone', mylib_repos, 'mylib')
            expect(described_class.current.instance('/app/mylib')).to be_nil
          end
        end

        context 'when subinstance not in HEAD and in git_current_revision' do
          it 'returns subinstance' do # rubocop:disable RSpec/ExampleLength
            app = init_git('app') # HEAD: master
            touch_commit(app, 'file3')
            app.execute!('branch', '-f', 'not_master')
            app.execute!('subrepo', 'clone', mylib_repos, 'mylib')
            app.execute!('checkout', 'not_master') # HEAD: not_master
            expect(described_class.current.instance('/app/mylib'))
              .to be_a(Avm::Launcher::Instances::Base)
          end
        end
      end
    end
  end
end
