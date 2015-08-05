require 'test_helper'

class FuncionarioTest < ActiveSupport::TestCase
  test "test empty cpf" do
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
  
  
  
end
