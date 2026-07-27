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
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'avm', '~> 0.102', '>= 0.102.3'
  s.add_dependency 'eac_rails_utils', '~> 0.29', '>= 0.29.3'
  s.add_dependency 'eac_ruby_utils', '~> 0.131', '>= 0.131.4'

  s.add_development_dependency 'eac_rails_gem_support', '~> 0.13', '>= 0.13.1'
end
