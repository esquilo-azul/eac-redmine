# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'eac_redmine_base0/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'eac_redmine_base0'
  s.version     = EacRedmineBase0::VERSION
  s.authors     = [EacRedmineBase0::VERSION]
  s.summary     = EacRedmineBase0::SUMMARY
  s.homepage    = EacRedmineBase0::HOMEPAGE

  s.files = Dir['{lib}/**/*', 'init.rb']
  s.required_ruby_version = '>= 2.7'

  # blankslate: required for the core 4.2.11 and not supplied in its Gemfile.
  s.add_dependency 'blankslate', '~> 3.1', '>= 3.1.3'
  s.add_dependency 'eac_ruby_utils', '~> 0.123'

  s.add_development_dependency 'eac_rails_gem_support', '~> 0.10', '>= 0.10.1'
end
