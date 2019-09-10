# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'redmine_avm/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'redmine_avm'
  s.version     = ::RedmineAvm::VERSION
  s.authors     = [::RedmineAvm::AUTHOR]
  s.summary     = ::RedmineAvm::SUMMARY
  s.homepage    = ::RedmineAvm::HOMEPAGE

  s.files = Dir['{app,config,db,lib}/**/*', 'init.rb']

  s.add_dependency 'aranha', '~> 0.10', '>= 0.10.1'
end
