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
          login(session)
          replicate(session, :pontos, :ponto)
          replicate(session, :funcionarios, :funcionario)
        end

        private

        def login(session)
          Rails.logger.debug "Efetuando login em #{server_url}..."
          fail "Login em \"#{server_url}\" falhou" unless session.login
          Rails.logger.debug 'Logado'
        end

        def replicate(session, session_method, entrada_tipo)
          Rails.logger.debug "Recuperando registros tipo \"#{entrada_tipo}\" em #{server_url}..."
          total = 0
          novos = 0
          ActiveRecord::Base.transaction do
            session.send(session_method).each_line do |line|
              novos += 1 if PontoTerminalEntrada.replicate(@ponto_terminal, entrada_tipo, line)
              total += 1
            end
          end
          Rails.logger.debug "Registros replicados: #{novos} novos de #{total} total"
        end

        def server_url
          "http://#{@ponto_terminal.endereco}/"
        end
      end
    end
  end
end
