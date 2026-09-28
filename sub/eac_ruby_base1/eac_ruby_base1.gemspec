# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_ruby_base1/version'

Gem::Specification.new do |s|
  s.name        = 'eac_ruby_base1'
  s.version     = EacRubyBase1::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH)
              .reject { |f| ['.', '..'].include?(File.basename(f)) }
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'eac_ruby_utils', '~> 0.131', '>= 0.131.2'

  s.add_development_dependency 'avm-eac_ruby_base1', '~> 0.42', '>= 0.42.1'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.13'
end
