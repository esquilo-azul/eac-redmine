# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Import
        module Ponto
          include Base

          def import_ponto(tpe)
            ActiveRecord::Base.transaction do
              r = Sjap::Ponto::Mte::AfdRegistroParser.parse_line(tpe.chave)
              unless r[:tipo] == Sjap::Ponto::Mte::AfdRegistroParser::TIPO_MARCACAO_PONTO
                fail "Registro não é de marcação de ponto: #{r}"
              end
              funcionario = ::Funcionario.find_by_pis(sanitize_pis(r[:pis]))
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

          def adf_registro_to_time(r, ponto_terminal)
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
end
