require 'test_helper'

class PontoCancelamentoTest < ActiveSupport::TestCase
  fixtures :users

  test 'impedimento cancelamento duplo' do
    f = Funcionario.new
    f.nome = 'João'
    f.matricula = 'AP01234'
    assert_equal true, f.save

    t = PontoTerminal.new
    t.descricao = 'Terminal 1'
    t.tipo = 'SUPERFACIL'
    t.endereco = 'localhost'
    t.usuario = 'usuario'
    t.senha = 'senha'
    t.fuso_horario = '-03:00'
    assert_equal true, t.save

    p = PontoEntrada.new
    p.data_hora = Time.zone.now
    p.funcionario = f
    p.terminal = t
    p.metodo = 'TERMINAL'
    assert_equal true, p.save

    c = PontoCancelamento.new
    c.ponto_entrada = p
    c.motivo = 'Esquecimento'
    User.current = users(:users_001)
    c.autor = users(:users_001)
    assert_equal true, c.save, c.errors.messages.inspect

    c = PontoCancelamento.new
    c.ponto_entrada = p
    c.motivo = 'Repetindo a entrada de ponto'
    User.current = users(:users_001)
    c.autor = users(:users_001)
    assert_not_equal true, c.save, 'Não pode haver mais de um cancelamento para uma entrada de ponto.'
    assert_equal false, c.errors.messages[:ponto_entrada].empty?
  end
end
