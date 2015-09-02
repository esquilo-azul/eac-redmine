# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Import
        def self.run_all
          import_tipo('funcionario')
        end

        def self.import_tipo(ponto_terminal_entrada_tipo)
          tpes = PontoTerminalEntrada.joins(:ponto_terminal).where(tipo: ponto_terminal_entrada_tipo, exportado_id: nil, ponto_terminals: { tipo: 'SUPERFACIL' })
          Rails.logger.debug "Entradas[tipo='#{ponto_terminal_entrada_tipo}', terminal.tipo='Super Fácil'] não-importadas encontradas: #{tpes.count}"
          tpes.each { |tpe| send('import_' + ponto_terminal_entrada_tipo, tpe) }
        end

        def self.import_funcionario(tpe)
          ActiveRecord::Base.transaction do
            r = Sjap::Ponto::SuperFacil::FuncionarioParser.parse_line(tpe.chave)
            matricula = ('ap' + r[:matricula]).upcase.strip
            pis = r[:pis].gsub(/^0+/, '')
            f = Funcionario.find_by_matricula(matricula)
            if f
              unless f.pis
                f.pis = pis
                Trf1Sjap::ModelUtils.save_or_raise(f)
              end
            else
              f = Funcionario.new
              f.nome = r[:nome]
              f.pis = pis
              f.matricula = matricula
              Trf1Sjap::ModelUtils.save_or_raise(f)
            end
            tpe.exportado = f
            Trf1Sjap::ModelUtils.save_or_raise(tpe)
          end
        end
      end
    end
  end
end
