# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_with_git/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_with_git'
  s.version     = ::RedmineWithGit::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Additional features for RedmineGitHosting.'

  s.files = Dir['{app,config,installer,lib}/**/*', 'init.rb']

  s.add_dependency 'avm-tools', '~> 0.48'
  s.add_dependency 'eac_rails_utils', '~> 0.11'
  s.add_dependency 'eac_ruby_utils', '~> 0.35'
end
