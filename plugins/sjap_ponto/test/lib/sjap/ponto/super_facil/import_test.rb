# encoding: UTF-8

require 'test_helper'
module Sjap
  module Ponto
    module SuperFacil
      class ImportTest < ActiveSupport::TestCase
        def test_parse_line
          f = Funcionario.new
          f.nome = 'Eduardo Henrique Bogoni'
          f.matricula = 'AP20199'
          f.pis = '13143342608'
          assert_save f

          pt = PontoTerminal.new
          pt.descricao = 'Terminal 1'
          pt.tipo = 'SUPERFACIL'
          pt.endereco = 'localhost'
          pt.usuario = 'usuario'
          pt.senha = 'senha'
          assert_save pt

          pte = PontoTerminalEntrada.new
          pte.chave = '0000543403140420151509013143342608'
          pte.tipo = 'ponto'
          pte.ponto_terminal = pt
          assert_save pte

          assert Import.import_ponto(pte)

          pte.reload
          assert pte.exportado
          assert pte.exportado.is_a?(PontoEntrada)

          pe = pte.exportado
          assert_equal 'TERMINAL', pe.metodo
          assert_equal pt, pe.terminal
          assert_equal Time.zone.local(2015, 4, 14, 15, 9), pe.data_hora
          assert_equal f, pe.funcionario
          assert_equal '', pe.motivo
        end

        def assert_save(record)
          record.save
          assert_equal({}, record.errors.messages)
        end
      end
    end
  end
end
