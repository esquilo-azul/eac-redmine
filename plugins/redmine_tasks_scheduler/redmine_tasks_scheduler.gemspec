# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_tasks_scheduler/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_tasks_scheduler'
  s.version     = RedmineTasksScheduler::VERSION
  s.authors     = [RedmineTasksScheduler::VERSION]
  s.summary     = RedmineTasksScheduler::SUMMARY
  s.homepage    = RedmineTasksScheduler::HOMEPAGE

  s.files = Dir['{app,config,lib}/**/*', 'init.rb']
  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency 'tasks_scheduler', '~> 0.9'

  s.add_development_dependency 'eac_rails_gem_support', '~> 0.10', '>= 0.10.1'
end
