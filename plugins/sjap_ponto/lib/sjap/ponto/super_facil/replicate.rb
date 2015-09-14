# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Replicate
        def initialize(ponto_terminal)
          @ponto_terminal = ponto_terminal
        end

        def run
          session = Sjap::Ponto::SuperFacil::Session.new(server_url, @ponto_terminal.usuario, @ponto_terminal.senha)
          login(session)
          replicate(session, :pontos, :ponto) do |l|
            Sjap::Ponto::Mte::AfdRegistroParser.parse_line(l)[:tipo] ==
              Sjap::Ponto::Mte::AfdRegistroParser::TIPO_MARCACAO_PONTO
          end
          replicate(session, :funcionarios, :funcionario) { |_l| true }
        end

        def self.run_all
          terminais = PontoTerminal.where(tipo: 'SUPERFACIL')
          Rails.logger.debug "Terminais \"Super Fácil\" encontrados: #{terminais.count}"
          terminais.each do |terminal|
            new(terminal).run
          end
        end

        private

        def login(session)
          Rails.logger.debug "Efetuando login em #{server_url}..."
          fail "Login em \"#{server_url}\" falhou" unless session.login
          Rails.logger.debug 'Logado'
        end

        def replicate(session, session_method, entrada_tipo, &condition)
          Rails.logger.debug "Recuperando registros tipo \"#{entrada_tipo}\" em #{server_url}..."
          total = 0
          novos = 0
          ActiveRecord::Base.transaction do
            session.send(session_method).each_line do |line|
              next unless condition.call(line)
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
