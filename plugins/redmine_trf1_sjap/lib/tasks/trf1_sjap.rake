# encoding: UTF-8

require 'yaml'
require 'highline/import'

namespace :trf1_sjap do
  tests = []
  %w(daemons_manager redmine_trf1_sjap sjap_ponto trf1_esosti).each do |plugin|
    tests << "plugins/#{plugin}/test/**/*_test.rb"
  end
  Rake::TestTask.new(test_all: 'db:test:prepare') do |t|
    t.libs << 'test'
    t.test_files = tests
    t.verbose = true
  end
  Rake::Task['trf1_sjap:test_all'].comment = 'Executa testes somente dos recursos desenvolvidos pela TRF1-SJAP.'
end
