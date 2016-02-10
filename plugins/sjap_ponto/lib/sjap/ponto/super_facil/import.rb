# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Import
        extend Sjap::Ponto::SuperFacil::Import::Funcionario
        extend Sjap::Ponto::SuperFacil::Import::Ponto

        class << self
          def run_all
            import_tipo('funcionario')
            import_tipo('ponto')
          end

          private

          def import_tipo(ponto_terminal_entrada_tipo)
            tpes = find_entradas_nao_exportadas(ponto_terminal_entrada_tipo)
            total = tpes.count
            Rails.logger.debug "Entradas[tipo='#{ponto_terminal_entrada_tipo}', "\
              "terminal.tipo='SUPERFACIL'] não-importadas encontradas: #{total}"
            imported = 0
            tpes.each do |tpe|
              imported += 1 if send('import_' + ponto_terminal_entrada_tipo, tpe)
            end
            Rails.logger.debug "Entradas[tipo='#{ponto_terminal_entrada_tipo}', "\
              "terminal.tipo='SUPERFACIL'] importadas: #{imported}/#{total}"
          end

          def find_entradas_nao_exportadas(ponto_terminal_entrada_tipo)
            PontoTerminalEntrada.joins(:ponto_terminal).where(
              tipo: ponto_terminal_entrada_tipo,
              exportado_id: nil,
              ponto_terminals: { tipo: 'SUPERFACIL' }
            )
          end
        end
      end
    end
  end
end
