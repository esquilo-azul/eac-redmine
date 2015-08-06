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
  Funcionario.where('cpf is not null').where('cef_id_solicitacoes_ultima_consulta is null or extract(seconds from (now() - cef_id_solicitacoes_ultima_consulta)) > 86400').each do |f|
    break unless $running
    Rails.logger.debug "Consultando para #{f} / #{f.cpf}"   
    begin      
      consulta = Trf1Sjap::CefId::ConsultaSolicitacoes.new(f.cpf)
      Rails.logger.debug "\tSolicitações encontradas: #{consulta.solicitacoes.count}"
      CefIdSolicitacao.import_from_consulta(f, consulta.solicitacoes)
    rescue SocketError, HTTPClient::BadResponseError, HTTPClient::KeepAliveDisconnected, HTTPClient::ReceiveTimeoutError, Errno::ECONNRESET => ex
      Rails.logger.warn ex    
    end
  end  
  sleep 120 if $running
end
