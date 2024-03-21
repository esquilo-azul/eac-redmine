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

  s.add_dependency 'eac_ruby_utils', '~> 0.121'

  s.add_development_dependency 'eac_rails_gem_support', '~> 0.9', '>= 0.9.2'
end
