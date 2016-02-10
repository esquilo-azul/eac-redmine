# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Import
        module Funcionario
          include Base

          def import_funcionario(tpe)
            ActiveRecord::Base.transaction do
              r = Sjap::Ponto::SuperFacil::FuncionarioParser.parse_line(tpe.chave)
              matricula = ('ap' + r[:matricula]).upcase.strip
              pis = sanitize_pis(r[:pis])
              f = ::Funcionario.find_by_matricula(matricula)
              if f
                unless f.pis
                  f.pis = pis
                  Trf1Sjap::ModelUtils.save_or_raise(f)
                end
              else
                f = ::Funcionario.new
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
        end
      end
    end
  end
end
