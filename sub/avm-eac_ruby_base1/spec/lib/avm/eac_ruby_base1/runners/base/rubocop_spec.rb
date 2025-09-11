# frozen_string_literal: true

RSpec.describe Avm::EacRubyBase1::Runners::Base::Rubocop do
  let(:fixtures_root) { Pathname.new(__dir__).expand_path.join('rubocop_spec_files') }
  let(:dir1) { fixtures_root.join('dir1') } # rubocop:disable RSpec/IndexedLet
  let(:dir2) { fixtures_root.join('dir2') } # rubocop:disable RSpec/IndexedLet
  let(:dir3) { dir1.join('dir3') } # rubocop:disable RSpec/IndexedLet
  let(:dir4) { fixtures_root.join('dir4') } # rubocop:disable RSpec/IndexedLet

  before do
    Avm::EacRubyBase1::Sources::Base.new(dir3).bundle.execute!
  end

  {
    dir1: '0.48.1',
    dir2: Avm::EacRubyBase1::Sources::Base.new(File.expand_path('../../../../../..', __dir__))
            .gemfile_lock_gem_version('rubocop').to_s,
    dir3: '0.48.1',
    dir4: '33.33.33'
  }.each do |dir_name, rubocop_version|
    context "when dir is #{dir_name}" do
      let(:dir) { send(dir_name) }
      let(:thegem) { Avm::EacRubyBase1::Sources::Base.new(dir) }

      it "return #{rubocop_version} as Rubocop version" do
        argv = ['-C', dir.to_s, '--', '--version']
        expect { described_class.run(argv: argv) }.to(
          output("#{rubocop_version}\n").to_stdout_from_any_process
        )
      end
    end
  end
end
