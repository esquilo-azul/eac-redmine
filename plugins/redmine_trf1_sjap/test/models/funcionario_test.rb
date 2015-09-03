require 'test_helper'

class FuncionarioTest < ActiveSupport::TestCase
  test 'test empty fields' do
    f = Funcionario.new
    f.nome = 'João'
    assert_equal false, f.save

    f.matricula = 'AP10001'
    assert_equal true, f.save

    f = Funcionario.new
    f.nome = 'Maria'
    f.matricula = 'AP10002'
    assert_equal true, f.save
  end

  test 'test valid cpf' do
    f = Funcionario.new
    f.nome = 'João'
    f.matricula = 'AP10001'
    f.cpf = 'abc def efg'
    assert_equal false, f.save

    f.cpf = '77446953561'
    assert_equal false, f.save

    f.cpf = '774.469.535-60'
    assert_equal false, f.save

    f.cpf = '77446953560'
    assert_equal true, f.save
  end

  test 'test unique cpf' do
    f = Funcionario.new
    f.nome = 'João'
    f.matricula = 'AP10001'
    f.cpf = '77446953560'
    assert_equal true, f.save

    f = Funcionario.new
    f.nome = 'Maria'
    f.matricula = 'AP10002'
    f.cpf = '77446953560'
    assert_equal false, f.save
  end

  test 'test unique matricula' do
    f = Funcionario.new
    f.nome = 'João'
    f.matricula = 'AP10001'
    assert_equal true, f.save

    f = Funcionario.new
    f.nome = 'Maria'
    f.matricula = 'AP10001'
    assert_equal false, f.save
  end

  test 'test valid pis' do
    f = Funcionario.new
    f.nome = 'João'
    f.matricula = 'AP10001'
    f.pis = 'abc def efg'
    assert_equal false, f.save

    f.pis = '120.1331.281-6'
    assert_equal false, f.save

    f.pis = '12013312811'
    assert_equal false, f.save

    f.pis = '12013312816'
    assert_equal true, f.save
  end

  test 'test unique pis' do
    f = Funcionario.new
    f.nome = 'João'
    f.matricula = 'AP10001'
    f.pis = '12013312816'
    assert_equal true, f.save

    f = Funcionario.new
    f.nome = 'Maria'
    f.matricula = 'AP10002'
    f.pis = '12013312816'
    assert_equal false, f.save
  end

  test 'test cef id consulta outdated' do
    f = Funcionario.new
    cpfs = [nil, '48777436423']
    now = Time.new(2015, 8, 17, 11, 16, 00, '+03:00')
    expected_values = {
      true => [
        nil,
        now - Funcionario.cef_id_solicitacoes_consulta_outdated_seconds - 1,
        Time.new(2015, 8, 16, 11, 15, 59, '+03:00')
      ],
      false => [
        now - Funcionario.cef_id_solicitacoes_consulta_outdated_seconds,
        now - Funcionario.cef_id_solicitacoes_consulta_outdated_seconds + 1,
        now,
        now + 1,
        Time.new(2015, 8, 16, 11, 16, 01, '+03:00')
      ]
    }
    cpfs.each do |cpf|
      expected_values.each do |expected_value, ultima_consulta_values|
        ultima_consulta_values.each do |ultima_consulta|
          f.cpf = cpf
          f.cef_id_solicitacoes_ultima_consulta = ultima_consulta
          expected_value = false if cpf.nil?
          assert_equal expected_value, f.cef_id_solicitacoes_consulta_outdated(now), "CPF: #{cpf}, Última consulta: #{ultima_consulta}"
        end
      end
    end
  end
end
