# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Import
        module Ponto
          include Base

          def import_ponto(pte)
            ActiveRecord::Base.transaction do
              r = parse_pte_chave(pte)
              funcionario = ::Funcionario.find_by_pis(sanitize_pis(r[:pis]))
              return false unless funcionario
              pte.exportado = create_ponto(pte, funcionario, r)
              pte.save!
              true
            end
          end

          def create_ponto(pte, funcionario, r)
            p = PontoEntrada.new(metodo: 'TERMINAL', terminal: pte.ponto_terminal,
                                 data_hora: adf_registro_to_time(r, pte.ponto_terminal),
                                 funcionario: funcionario, motivo: '')
            p.save!
            p
          end

          def parse_pte_chave(pte)
            r = Sjap::Ponto::Mte::AfdRegistroParser.parse_line(pte.chave)
            return r if r[:tipo] == Sjap::Ponto::Mte::AfdRegistroParser::TIPO_MARCACAO_PONTO
            fail "Registro não é de marcação de ponto: #{r}"
          end

          def adf_registro_to_time(r, ponto_terminal)
            ponto_terminal.build_time(
              *adf_registro_data(r), *adf_registro_hora(r), 0
            )
          end

          def adf_registro_data(r)
            [r[:data][4, 4].to_i,
             r[:data][2, 2].to_i,
             r[:data][0, 2].to_i]
          end

          def adf_registro_hora(r)
            [r[:horario][0, 2].to_i,
             r[:horario][2, 2].to_i]
          end
        end
      end
    end
  end
end
