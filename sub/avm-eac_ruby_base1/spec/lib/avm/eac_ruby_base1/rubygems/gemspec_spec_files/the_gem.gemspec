# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'the_gem'
  s.version     = '0.0.0'

  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'avm', '~> 0.94'
  s.add_dependency 'avm-eac_generic_base0', '~> 0.13'
  s.add_dependency 'eac_envs-http', '~> 0.5', '>= 0.5.1'
  s.add_dependency 'eac_ruby_utils', '~> 0.122'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.10'
end
