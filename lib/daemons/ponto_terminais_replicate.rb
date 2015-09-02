#!/usr/bin/env ruby

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

while($running) do
  begin
    Sjap::Ponto::SuperFacil::Replicate.run_all
  rescue Exception => ex
    Rails.logger.warn ex
  end
  begin
    Sjap::Ponto::SuperFacil::Import.run_all
  rescue Exception => ex
    Rails.logger.warn ex
  end
  sleep_time = Setting.plugin_sjap_ponto['terminais_replicate_pause'].to_i
  Rails.logger.debug "Aguardando #{sleep_time} segundos"
  sleep sleep_time
end
