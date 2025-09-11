# frozen_string_literal: true

RSpec.shared_examples 'avm_source_generated' do |spec_file, stereotype, options = {}|
  include_context 'spec_paths', spec_file
  block_on_each_source = options.delete(:block_on_each_source)

  spec_paths_controller.fixtures_directory.children.select(&:directory?).each do |target_dir|
    context "when target is \"#{target_dir.basename}\"" do
      let(:source) { avm_source(stereotype, options.merge(target_basename: target_dir.basename)) }

      it do
        expect(fs_comparator.build(source.path)).to eq(fs_comparator.build(target_dir))
      end

      instance_exec(&block_on_each_source) if block_on_each_source
    end
  end

  # @return [EacFs::Comparato]
  def fs_comparator
    EacFs::Comparator.new.rename_file('.gitignore', '_gitignore')
  end
end
