# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_tasks_scheduler/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_tasks_scheduler'
  s.version     = ::RedmineTasksScheduler::VERSION
  s.authors     = [::RedmineTasksScheduler::VERSION]
  s.summary     = ::RedmineTasksScheduler::SUMMARY
  s.homepage    = ::RedmineTasksScheduler::HOMEPAGE

  s.files = Dir['{app,config,lib}/**/*', 'init.rb']

  s.add_dependency 'tasks_scheduler', '~> 0.4', '>= 0.4.2'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.1', '>= 0.1.2'
end
