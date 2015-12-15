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
            r = Sjap::Ponto::Mte::AfdRegistroParser.parse_line(tpe.chave)
            unless r[:tipo] == Sjap::Ponto::Mte::AfdRegistroParser::TIPO_MARCACAO_PONTO
              fail "Registro não é de marcação de ponto: #{r}"
            end
            funcionario = Funcionario.find_by_pis(sanitize_pis(r[:pis]))
            if funcionario
              p = PontoEntrada.new
              p.metodo = 'TERMINAL'
              p.terminal = tpe.ponto_terminal
              p.data_hora = adf_registro_to_time(r, tpe.ponto_terminal)
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

        def self.adf_registro_to_time(r, ponto_terminal)
          ponto_terminal.build_time(
            r[:data][4, 4].to_i,
            r[:data][2, 2].to_i,
            r[:data][0, 2].to_i,
            r[:horario][0, 2].to_i,
            r[:horario][2, 2].to_i,
            0
          )
        end
      end
    end
  end
end
