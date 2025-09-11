# frozen_string_literal: true

RSpec.describe Avm::EacRubyBase1::SourceGenerators::Base do
  include_examples 'avm_source_generated', __FILE__, 'EacRubyBase1',
                   {
                     'eac-ruby-utils-version' => '0.35.0',
                     'eac-ruby-gem-support-version' => '0.2.0',
                     'gemfile-lock' => true
                   }

  alias_method :fs_comparator_super, :fs_comparator

  def fs_comparator
    fs_comparator_super.truncate_file('Gemfile.lock')
  end
end
