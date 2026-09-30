# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_rails_gem_support/version'

Gem::Specification.new do |s|
  s.name        = 'eac_rails_gem_support'
  s.version     = EacRailsGemSupport::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir.glob('{lib,template}/**/*', File::FNM_DOTMATCH)
              .reject { |f| ['.', '..'].include?(File.basename(f)) }

  s.required_ruby_version = '>= 3.2' # rubocop:disable Gemspec/RequiredRubyVersion

  s.add_dependency 'avm-eac_ruby_base1', '~> 0.45', '>= 0.45.2'
  s.add_dependency 'capybara', '~> 3.40'
  s.add_dependency 'eac_ruby_base1', '~> 0.1', '>= 0.1.1'
  s.add_dependency 'eac_ruby_gem_support', '~> 0.15'
  s.add_dependency 'eac_templates', '~> 0.9'
  s.add_dependency 'factory_bot_rails', '~> 6.5', '>= 6.5.1'
  s.add_dependency 'launchy', '~> 2.5', '>= 2.5.2'
  s.add_dependency 'letter_opener', '~> 1.10'
  s.add_dependency 'rails', '>= 7.2'
  s.add_dependency 'rspec-rails', '~> 8.0', '>= 8.0.4'
  s.add_dependency 'sqlite3', '~> 2.9', '>= 2.9.6'
end
