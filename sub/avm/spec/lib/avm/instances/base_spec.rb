# frozen_string_literal: true

RSpec.describe Avm::Instances::Base do
  it do
    expect(described_class.ancestors.map(&:name)).to(
      include('Avm::Instances::Base::Install')
    )
  end

  include_examples 'entries_values', __FILE__, {
    'app_0' => {
      Avm::Instances::EntryKeys::INSTALL_DATA_PATH => '/data_fs_root/app_0',
      Avm::Instances::EntryKeys::INSTALL_PATH => '/fs_root/app_0',
      Avm::Instances::EntryKeys::DATABASE_NAME => 'app_0',
      Avm::Instances::EntryKeys::DATABASE_USERNAME => 'user1',
      Avm::Instances::EntryKeys::DATABASE_PASSWORD => 'pass1',
      Avm::Instances::EntryKeys::DATABASE_HOSTNAME => 'database.net',
      Avm::Instances::EntryKeys::DATABASE_PORT => 5432,
      Avm::Instances::EntryKeys::INSTALL_HOSTNAME => 'myhost.com',
      Avm::Instances::EntryKeys::INSTALL_USERNAME => 'myuser',
      Avm::Instances::EntryKeys::INSTALL_GROUPNAME => 'myuser',
      Avm::Instances::EntryKeys::INSTALL_URL => 'ssh://otheruser@otherhost.com',
      Avm::Instances::EntryKeys::WEB_URL => 'https://app0.net',
      Avm::Instances::EntryKeys::WEB_PATH => ''
    },
    'app_2' => {
      Avm::Instances::EntryKeys::DATABASE_HOSTNAME => '127.0.0.1',
      Avm::Instances::EntryKeys::INSTALL_GROUPNAME => 'myuser',
      Avm::Instances::EntryKeys::SOURCE_INSTANCE_ID => 'app_dev'
    },
    'app_3' => {
      Avm::Instances::EntryKeys::DATABASE_SYSTEM => 'postgresql',
      Avm::Instances::EntryKeys::DATABASE_NAME => 'app_1_db',
      Avm::Instances::EntryKeys::DATABASE_USERNAME => 'user1',
      Avm::Instances::EntryKeys::DATABASE_PASSWORD => 'pass1',
      Avm::Instances::EntryKeys::DATABASE_HOSTNAME => 'database.net',
      Avm::Instances::EntryKeys::DATABASE_PORT => 5432,
      Avm::Instances::EntryKeys::MAILER_ID => 'mailer_0',
      Avm::Instances::EntryKeys::MAILER_FROM => 'noreply@example.net',
      Avm::Instances::EntryKeys::MAILER_REPLY_TO => nil,
      Avm::Instances::EntryKeys::MAILER_SMTP_ADDRESS => 'smtp.example.net',
      Avm::Instances::EntryKeys::MAILER_SMTP_PORT => '587',
      Avm::Instances::EntryKeys::MAILER_SMTP_DOMAIN => 'example.net',
      Avm::Instances::EntryKeys::MAILER_SMTP_USERNAME => 'a_user',
      Avm::Instances::EntryKeys::MAILER_SMTP_PASSWORD => 'a_secret',
      Avm::Instances::EntryKeys::MAILER_SMTP_AUTHENTICATION => 'plain',
      Avm::Instances::EntryKeys::MAILER_SMTP_STARTTLS_AUTO => 'true'
    },
    'app_4' => {
      Avm::Instances::EntryKeys::INSTALL_SCHEME => 'ssh',
      Avm::Instances::EntryKeys::INSTALL_HOSTNAME => 'host4.net',
      Avm::Instances::EntryKeys::INSTALL_USERNAME => 'user4',
      Avm::Instances::EntryKeys::INSTALL_GROUPNAME => 'group4',
      Avm::Instances::EntryKeys::INSTALL_URL => 'ssh://user4@host4.net'
    },
    'app_5' => {
      Avm::Instances::EntryKeys::INSTALL_SCHEME => 'ssh',
      Avm::Instances::EntryKeys::INSTALL_HOSTNAME => 'host5.net',
      Avm::Instances::EntryKeys::INSTALL_PORT => '2222',
      Avm::Instances::EntryKeys::INSTALL_USERNAME => 'user5',
      Avm::Instances::EntryKeys::INSTALL_PASSWORD => 'passwd5',
      Avm::Instances::EntryKeys::INSTALL_PATH => '/path/to/app5'
    },
    'app_6' => {
      Avm::Instances::EntryKeys::INSTALL_SCHEME => 'ssh',
      Avm::Instances::EntryKeys::INSTALL_HOSTNAME => 'host5.net',
      Avm::Instances::EntryKeys::INSTALL_PORT => '2222',
      Avm::Instances::EntryKeys::INSTALL_USERNAME => 'user5',
      Avm::Instances::EntryKeys::INSTALL_PASSWORD => 'passwd5',
      Avm::Instances::EntryKeys::INSTALL_PATH => '/path/to/app5/app_6'
    },
    'mailer_0' => {
      Avm::Instances::EntryKeys::MAILER_FROM => 'noreply@example.net',
      Avm::Instances::EntryKeys::MAILER_REPLY_TO => '',
      Avm::Instances::EntryKeys::MAILER_SMTP_ADDRESS => 'smtp.example.net',
      Avm::Instances::EntryKeys::MAILER_SMTP_PORT => '587',
      Avm::Instances::EntryKeys::MAILER_SMTP_DOMAIN => 'example.net',
      Avm::Instances::EntryKeys::MAILER_SMTP_USERNAME => 'a_user',
      Avm::Instances::EntryKeys::MAILER_SMTP_PASSWORD => 'a_secret',
      Avm::Instances::EntryKeys::MAILER_SMTP_AUTHENTICATION => 'plain',
      Avm::Instances::EntryKeys::MAILER_SMTP_STARTTLS_AUTO => 'true'
    }
  }

  describe '#by_id' do
    {
      'avm-tools_0' => %w[avm-tools 0],
      'avm-tools_dev' => %w[avm-tools dev],
      'redmine1-abc2_dev3' => %w[redmine1-abc2 dev3]
    }.each do |id, expected|
      context "when input ID is \"#{id}\"" do
        let(:instance) { described_class.by_id(id) }

        it "returns application.id=#{expected.first}" do
          expect(instance.application.id).to eq(expected.first)
        end

        it "returns instance.suffix=#{expected.last}" do
          expect(instance.suffix).to eq(expected.last)
        end
      end
    end
  end
end
