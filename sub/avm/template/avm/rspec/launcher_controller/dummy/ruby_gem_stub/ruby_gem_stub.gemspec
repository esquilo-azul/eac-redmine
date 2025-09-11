# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'ruby_gem_stub/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'ruby_gem_stub'
  s.version     = RubyGemStub::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Ruby gem stub for tests.'
  s.files = Dir['{lib}/**/*']
  s.required_ruby_version = '>= 2.7.0'
end
