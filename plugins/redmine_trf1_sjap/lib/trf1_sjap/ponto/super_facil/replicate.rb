# encoding: UTF-8

module Trf1Sjap
  module Ponto
    module SuperFacil
      class Replicate
        def initialize(ponto_terminal)
          @ponto_terminal = ponto_terminal
        end

        def run
          session = Trf1Sjap::Ponto::SuperFacil::Session.new(server_url, @ponto_terminal.usuario, @ponto_terminal.senha)
          Rails.logger.debug "Efetuando login em #{server_url}..."
          fail "Login em \"#{server_url}\" falhou" unless session.login
          Rails.logger.debug 'Logado'
          start_date = Time.new(1900, 01, 01)
          end_date = Time.now
          Rails.logger.debug "Recuperando registros de ponto em #{server_url} de #{start_date} a #{end_date}..."
          total = 0
          novos = 0
          ActiveRecord::Base.transaction do
            session.registros(start_date, end_date).each_line do |line|
              novos += 1 if PontoTerminalEntrada.replicate(@ponto_terminal, :ponto, line)
              total += 1
            end
          end
          Rails.logger.debug "Registros replicados: #{novos} novos de #{total} total"
        end

        private

        def server_url
          "http://#{@ponto_terminal.endereco}/"
        end
      end
    end
  end
end
