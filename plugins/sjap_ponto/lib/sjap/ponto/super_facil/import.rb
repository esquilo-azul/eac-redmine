# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Import
        def self.run_all
          import_tipo('funcionario')
          import_tipo('ponto')
        end

        def self.import_tipo(ponto_terminal_entrada_tipo)
          tpes = PontoTerminalEntrada.joins(:ponto_terminal).where(tipo: ponto_terminal_entrada_tipo, exportado_id: nil, ponto_terminals: { tipo: 'SUPERFACIL' })
          total = tpes.count
          Rails.logger.debug "Entradas[tipo='#{ponto_terminal_entrada_tipo}', terminal.tipo='SUPERFACIL'] não-importadas encontradas: #{total}"
          imported = 0
          tpes.each do |tpe|
            imported += 1 if send('import_' + ponto_terminal_entrada_tipo, tpe)
          end
          Rails.logger.debug "Entradas[tipo='#{ponto_terminal_entrada_tipo}', terminal.tipo='SUPERFACIL'] importadas: #{imported}/#{total}"
        end

        def self.import_funcionario(tpe)
          ActiveRecord::Base.transaction do
            r = Sjap::Ponto::SuperFacil::FuncionarioParser.parse_line(tpe.chave)
            matricula = ('ap' + r[:matricula]).upcase.strip
            pis = sanitize_pis(r[:pis])
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
          true
        end

        def self.import_ponto(tpe)
          ActiveRecord::Base.transaction do
            r = Sjap::Ponto::SuperFacil::PontoParser.parse_line(tpe.chave)
            funcionario = Funcionario.find_by_pis(sanitize_pis(r[:pis]))
            if funcionario
              p = PontoEntrada.new
              p.metodo = 'TERMINAL'
              p.terminal = tpe.ponto_terminal
              p.data_hora = Time.new(r[:year], r[:month], r[:day], r[:hours], r[:minutes])
              p.funcionario = funcionario
              p.motivo = ''
              Trf1Sjap::ModelUtils.save_or_raise(p)
              tpe.exportado = p
              Trf1Sjap::ModelUtils.save_or_raise(tpe)
              true
            else
              false
            end
          end
        end

        def self.sanitize_pis(pis)
          pis.gsub(/^0+/, '')
        end
      end
    end
  end
end
