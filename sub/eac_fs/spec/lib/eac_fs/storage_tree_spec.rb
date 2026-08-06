# frozen_string_literal: true

RSpec.describe EacFs::StorageTree do
  let(:tmpdir) { Dir.mktmpdir }
  let(:instance) { described_class.new(tmpdir, 'instance') }

  it { expect(instance.read).to be_blank }
  it { expect(instance.stored?).to be(false) }

  context 'when instance is writed' do
    before { instance.write('STUB') }

    it { expect(instance.read).to eq('STUB') }
    it { expect(instance.stored?).to be(true) }

    context 'when instance is cleared' do
      before { instance.clear }

      it { expect(instance.read).to be_blank }
      it { expect(instance.stored?).to be(false) }
    end
  end

  describe '#child' do
    let(:child) { instance.child('child') }

    it { expect(child.path).to match(/\A#{Regexp.quote(instance.path)}/) }
  end
end
