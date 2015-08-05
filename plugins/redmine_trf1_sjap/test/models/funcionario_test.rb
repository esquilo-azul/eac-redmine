require 'test_helper'

class FuncionarioTest < ActiveSupport::TestCase
  test "test empty fields" do
    f = Funcionario.new
    f.nome = "João"
    assert_equal true, f.save
    
    f = Funcionario.new
    f.nome = "Maria"
    assert_equal true, f.save
  end
  
  test "test valid cpf" do
    f = Funcionario.new
    f.nome = "João"
    f.cpf = 'abc def efg'
    assert_equal false, f.save
    
    f.cpf = '77446953561'
    assert_equal false, f.save
    
    f.cpf = '774.469.535-60'
    assert_equal false, f.save
    
    f.cpf = '77446953560'
    assert_equal true, f.save
  end
  
  test "test unique cpf" do
    f = Funcionario.new
    f.nome = "João"
    f.cpf = '77446953560'
    assert_equal true, f.save

    f = Funcionario.new
    f.nome = "Maria"
    f.cpf = '77446953560'
    assert_equal false, f.save
  end

  test "test unique matricula" do
    f = Funcionario.new
    f.nome = "João"
    f.matricula = 'AP10001'
    assert_equal true, f.save
    
    f = Funcionario.new
    f.nome = "Maria"
    f.matricula = 'AP10001'
    assert_equal false, f.save
    
    f = Funcionario.new
    f.nome = "Maria"
    f.matricula = 'ap10001'
    assert_equal false, f.save
  end

  test 'test valid pis' do
    f = Funcionario.new
    f.nome = 'João'
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
    f.pis = '12013312816'
    assert_equal true, f.save

    f = Funcionario.new
    f.nome = 'João'
    f.pis = '12013312816'
    assert_equal false, f.save
  end
end
