# encoding: UTF-8

require 'test_helper'

class Trf1Sjap::EadminHttpSessionTest < ActiveSupport::TestCase
  def test_not_logged
    session = Trf1Sjap::EadminHttpSession.new('','','')
    page = File.read(File.dirname(__FILE__) + "/eadmin-login-error.html");
    assert_equal(false, session.loggedUser?(page))    
  end
  
  def test_logged
    session = Trf1Sjap::EadminHttpSession.new('','','')
    page = File.read(File.dirname(__FILE__) + "/solicitacao-detalhes_749708.html");
    assert_equal('AP20199 - EDUARDO HENRIQUE BOGONI', session.loggedUser?(page))    
  end
  
  private
  
  def file_test(file_name, expected_result)
    
    caixa = Trf1Sjap::CaixaAtendimentoSecao.new(page)
    result = caixa.solicitacoes    
    assert_equal expected_result, result
  end

end
