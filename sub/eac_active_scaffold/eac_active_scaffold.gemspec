# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_active_scaffold/version'

Gem::Specification.new do |s|
  s.name        = 'eac_active_scaffold'
  s.version     = EacActiveScaffold::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{app,config,lib}/**/*']
  s.required_ruby_version = '>= 2.7' # rubocop:disable Gemspec/RequiredRubyVersion

  s.add_dependency 'active_scaffold', '~> 4.3', '>= 4.3.2'
  s.add_dependency 'dartsass-sprockets', '~> 3.2', '>= 3.2.1'
  s.add_dependency 'eac_rails_utils', '~> 0.32'
  s.add_dependency 'eac_ruby_utils', '~> 0.134', '>= 0.134.1'
  s.add_dependency 'recordselect', '~> 3.10', '>= 3.10.9'

  s.add_development_dependency 'eac_rails_gem_support', '~> 0.15'
end
