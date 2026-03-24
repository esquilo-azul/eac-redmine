# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_fs/version'

Gem::Specification.new do |s|
  s.name        = 'eac_fs'
  s.version     = EacFs::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib}/**/*']
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'content-type', '~> 0.0', '>= 0.0.2'
  s.add_dependency 'eac_ruby_utils', '~> 0.130'
  s.add_dependency 'filesize', '~> 0.2'
  s.add_dependency 'ruby-filemagic', '~> 0.7', '>= 0.7.3'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.12', '>= 0.12.2'
end
