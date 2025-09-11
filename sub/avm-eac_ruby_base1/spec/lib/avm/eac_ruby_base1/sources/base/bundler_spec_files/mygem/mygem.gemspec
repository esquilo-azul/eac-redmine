# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'mygem'
  s.version     = '1.0.0'
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Stub gem.'

  s.files = Dir['{exe,lib}/**/*', 'Gemfile', 'Rakefile']
  s.bindir = 'exe'
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'rake'
end
