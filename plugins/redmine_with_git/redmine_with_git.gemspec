# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_with_git/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_with_git'
  s.version     = RedmineWithGit::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Additional features for RedmineGitHosting.'

  s.files = Dir['{app,config,installer,lib}/**/*', 'init.rb']
  s.required_ruby_version = '>= 3.2' # rubocop:disable Gemspec/RequiredRubyVersion

  s.add_dependency 'avm', '~> 0.102', '>= 0.102.4'
  s.add_dependency 'eac_rails_utils', '~> 0.31'
  s.add_dependency 'eac_ruby_utils', '~> 0.133'
  s.add_dependency 'html-pipeline', '< 3'
  s.add_dependency 'redcarpet'
  s.add_dependency 'sidekiq'

  s.add_development_dependency 'eac_rails_gem_support', '~> 0.15'
end
