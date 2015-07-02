#!/usr/bin/env ruby
# encoding: UTF-8

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

sync_threads = {}

Thread.abort_on_exception = true if Rails.env.development?
continue_callback = Proc.new do |dist, *args|
  $running
end

while $running do 
  for trf1_sjap_project in Trf1SjapProject.all
    if ! sync_threads.has_key? trf1_sjap_project
      Rails.logger.info "Criando thread para " + trf1_sjap_project.to_s
      sync_threads[trf1_sjap_project] = Trf1Sjap::EsostiProjectReplicate.new(trf1_sjap_project, continue_callback)    
    end
  end
  sleep(5)
end

sync_threads.each do |key, value|
  Rails.logger.info "Aguardando threads de projetos"
  value.join
end

