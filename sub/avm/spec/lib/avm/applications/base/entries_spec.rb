# frozen_string_literal: true

RSpec.describe Avm::Applications::Base, '#entries' do
  include_examples 'entries_values', __FILE__, {
    'app0' => {
      'name' => 'Application 0',
      'organization' => nil,
      'scm.id' => 'app1',
      'scm.type' => 'ScmX',
      'scm.url' => 'http://nowhere.net/anypath',
      'scm.repos_path' => 'mygroup/app0',
      'scm.ssh_username' => 'myuser'
    },
    'app1' => {
      'name' => nil,
      'organization' => 'org1',
      'scm.id' => nil,
      'scm.type' => 'ScmX',
      'scm.url' => 'http://nowhere.net/anypath',
      'scm.repos_path' => 'mygroup',
      'scm.ssh_username' => 'myuser'
    }
  }

  # @return [Avm::Entries::Base]
  def build_instance(instance_id)
    described_class.new(instance_id)
  end
end
