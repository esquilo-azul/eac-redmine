# encoding: UTF-8

require 'test_helper'
module Sjap
  module Ponto
    module SuperFacil
      class ImportTest < ActiveSupport::TestCase
        def setup
          @funcionario = Funcionario.new
          @funcionario.nome = 'Eduardo Henrique Bogoni'
          @funcionario.matricula = 'AP20199'
          @funcionario.pis = '13143342608'
          assert_save @funcionario

          @funcionario1 = Funcionario.new(nome: 'Fulano', matricula: 'AP1234', pis: '19036107493')
          assert_save @funcionario1

          @ponto_terminal = PontoTerminal.new
          @ponto_terminal.descricao = 'Terminal 1'
          @ponto_terminal.tipo = 'SUPERFACIL'
          @ponto_terminal.endereco = 'localhost'
          @ponto_terminal.usuario = 'usuario'
          @ponto_terminal.senha = 'senha'
          @ponto_terminal.fuso_horario = '-03:00'
          assert_save @ponto_terminal
        end

        def test_parse_line
          pte = PontoTerminalEntrada.new
          pte.chave = '0000543403140420151509013143342608'
          pte.tipo = 'ponto'
          pte.ponto_terminal = @ponto_terminal
          assert_save pte

          assert Import.import_ponto(pte)

          pte.reload
          assert pte.exportado
          assert pte.exportado.is_a?(PontoEntrada)

          pe = pte.exportado
          assert_equal 'TERMINAL', pe.metodo
          assert_equal @ponto_terminal, pe.terminal
          assert_equal Time.new(2015, 4, 14, 15, 9, 0, '-03:00'), pe.data_hora
          assert_equal @funcionario, pe.funcionario
          assert_equal '', pe.motivo
        end

        def test_parse_line_dois
          pte = PontoTerminalEntrada.new
          pte.chave = '0000727083240920150836019036107493'
          pte.tipo = 'ponto'
          pte.ponto_terminal = @ponto_terminal
          assert_save pte

          assert Import.import_ponto(pte)

          pte.reload
          assert pte.exportado
          assert pte.exportado.is_a?(PontoEntrada)

          pe = pte.exportado
          assert_equal 'TERMINAL', pe.metodo
          assert_equal @ponto_terminal, pe.terminal
          assert_equal Time.new(2015, 9, 24, 8, 36, 0, '-03:00'), pe.data_hora
          assert_equal @funcionario1, pe.funcionario
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
