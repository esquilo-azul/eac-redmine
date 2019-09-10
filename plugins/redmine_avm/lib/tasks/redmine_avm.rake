# frozen_string_literal: true

namespace :redmine_avm do
  Rake::TestTask.new(test: 'db:test:prepare') do |t|
    plugin_root = ::File.dirname(::File.dirname(__dir__))

    t.description = 'Run plugin redmine_avm\'s tests.'
    t.libs << 'test'
    t.test_files = FileList["#{plugin_root}/test/**/*_test.rb"]
    t.verbose = false
    t.warning = false
  end
end
