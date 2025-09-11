# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'avm/version'

Gem::Specification.new do |s|
  s.name        = 'avm'
  s.version     = Avm::VERSION
  s.authors     = ['Eduardo H. Bogoni']
  s.summary     = 'Ruby base library for Agora Vai! Methodology (https://avm.esquiloazul.tech).'

  s.files = Dir['{lib,locale,template}/**/{*,.*}']
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'clipboard', '~> 1.4', '>= 1.4.1'
  s.add_dependency 'eac_cli', '~> 0.44', '>= 0.44.1'
  s.add_dependency 'eac_config', '~> 0.15'
  s.add_dependency 'eac_docker', '~> 0.8'
  s.add_dependency 'eac_fs', '~> 0.19', '>= 0.19.1'
  s.add_dependency 'eac_ruby_utils', '~> 0.128', '>= 0.128.4'
  s.add_dependency 'eac_templates', '~> 0.8', '>= 0.8.1'
  s.add_dependency 'minitar', '~> 0.12', '>= 0.12.1'

  s.add_development_dependency 'avm-eac_ruby_base1', '~> 0.38'
  s.add_development_dependency 'avm-git', '~> 0.21'
  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.12'
end
