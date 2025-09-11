# frozen_string_literal: true

RSpec.describe Avm::EacRubyBase1::Sources::Base, '#bundler' do
  let(:mygem_path) { Pathname.new(__dir__).join('bundler_spec_files', 'mygem') }
  let(:mygem) { described_class.new(mygem_path) }

  before do
    mygem.bundle.execute!
  end

  describe '#bundle' do
    specify do
      expect(mygem.bundle('exec', 'myrunner').execute!).to include('My Runner')
    end
  end

  describe '#gemfile_source' do
    it do
      expect(mygem.gemfile_source).to eq(Addressable::URI.parse('https://rubygems.org'))
    end
  end

  describe '#rake' do
    specify do
      expect(mygem.rake('mygem:stub').execute!).to include('Stub!')
    end
  end
end
