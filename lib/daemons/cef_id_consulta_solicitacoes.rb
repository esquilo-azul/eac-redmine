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
  funcionarios = Funcionario.find_all_cef_id_solicitacoes_consulta_outdated
  Rails.logger.debug "Funcionários desatualizados: #{funcionarios.count}"
  funcionarios.each do |f|
    break unless $running
    Rails.logger.info "Consultando para #{f} / #{f.cpf}"   
    begin      
      consulta = Trf1Sjap::CefId::ConsultaSolicitacoes.new(f.cpf)
      Rails.logger.info "\tSolicitações encontradas: #{consulta.solicitacoes.count}"
      CefIdSolicitacao.import_from_consulta(f, consulta.solicitacoes)
    rescue SocketError, HTTPClient::BadResponseError, HTTPClient::KeepAliveDisconnected, HTTPClient::ReceiveTimeoutError, Errno::ECONNRESET => ex
      Rails.logger.warn ex    
    end
  end
  sleep_time=60
  Rails.logger.debug "Esperando #{sleep_time} segundos até a próxima execução"
  sleep sleep_time if $running
end
