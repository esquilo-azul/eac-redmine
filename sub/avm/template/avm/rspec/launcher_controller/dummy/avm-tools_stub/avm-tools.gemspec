# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'avm/tools/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'avm/tools'
  s.version     = Avm::Tools::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Utilities to deploy applications and libraries.'
  s.license     = 'MIT'

  s.files = Dir['{exe,lib}/**/*', 'Gemfile', 'MIT-LICENSE', 'README.rdoc']
  s.required_ruby_version = '>= 2.7.0'
  s.bindir = 'exe'
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }

  s.add_dependency 'activesupport', '~> 4.2', '>= 4.2.10'
  s.add_dependency 'colorize', '~> 0.8.1'
  s.add_dependency 'curb', '~> 0.9.4'
  s.add_dependency 'eac_rails_utils', '~> 0.1', '>= 0.1.14'
  s.add_dependency 'eac_ruby_utils', '~> 0.1'
  s.add_dependency 'git', '~> 1.3.0'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop', '~> 0.48.1'
end
