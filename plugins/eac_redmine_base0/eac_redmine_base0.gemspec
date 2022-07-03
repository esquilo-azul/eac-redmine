# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'eac_redmine_base0/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'eac_redmine_base0'
  s.version     = ::EacRedmineBase0::VERSION
  s.authors     = [::EacRedmineBase0::VERSION]
  s.summary     = ::EacRedmineBase0::SUMMARY
  s.homepage    = ::EacRedmineBase0::HOMEPAGE

  s.files = Dir['{app,config,lib}/**/*', 'init.rb']

  s.add_dependency 'avm-tools', '~> 0.62', '>= 0.62.4'
  s.add_dependency 'eac_ruby_gems_utils', '~> 0.4'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5.1'
end
