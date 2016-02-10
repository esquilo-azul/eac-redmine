# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Import
        module Funcionario
          include Base

          def import_funcionario(pte)
            ActiveRecord::Base.transaction do
              r = Sjap::Ponto::SuperFacil::FuncionarioParser.parse_line(pte.chave)
              matricula = ('ap' + r[:matricula]).upcase.strip
              pis = sanitize_pis(r[:pis])
              return false unless pis.to_s.length <= 11
              pte.exportado = find_funcionario(matricula, pis, r[:nome])
              pte.save!
            end
            true
          end

          private

          def find_funcionario(matricula, pis, nome)
            f = ::Funcionario.find_by_matricula(matricula)
            if f
              f.update_attributes!(pis: pis) unless f.pis
            else
              f = ::Funcionario.new(nome: nome, pis: pis, matricula: matricula)
              f.save!
            end
            f
          end
        end
      end
    end
  end
end
