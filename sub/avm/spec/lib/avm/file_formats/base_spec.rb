# frozen_string_literal: true

RSpec.describe Avm::FileFormats::Base do
  include_examples 'avm_file_format_file_resource_name', {
    'app/models/mynamespace/the_class.rb' => 'app/models/mynamespace/the_class.rb',
    'lib/ruby/lib/cliutils/eac_redmine_base0/activity.rb' =>
      'lib/ruby/lib/cliutils/eac_redmine_base0/activity.rb'
  }
end
