# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'mygem/version'

Gem::Specification.new do |s|
  s.name        = 'mygem'
  s.version     = Mygem::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib}/**/*']
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'eac_ruby_utils', '~> 0.35'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.2'
end
