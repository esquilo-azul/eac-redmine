# frozen_string_literal: true

namespace :eac_redmine_base0 do
  desc 'Execute a system command'
  task :system, [:command_string] => :environment do |_t, args|
    EacRedmineBase0::Tasks::System.new(args.command_string).perform
  end
end
