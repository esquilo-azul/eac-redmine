# encoding: UTF-8

require File.expand_path('../../../../test_helper', __FILE__)

class Trf1Sjap::SolicitacaoDetalhesTest < ActiveSupport::TestCase
  def test_updates
    file_test('solicitacao-detalhes_817986_2015-05-25_12-50-00.html', [{
        'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 25/05/2015 12:45:05 0D 0h 0m 51s',
        'Por' => 'AP23PS - ADERVAN FRANS GUIMARAES MIRA JUNIOR',
        'Descrição' => '+ em atendimento'
      },{
        'Fase' => 'CADASTRO SOLICITAÇÃO TI 25/05/2015 12:44:14 0D 0h 0m 0s',
        'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): SEÇÃO JUDICIÁRIA DO AMAPÁ - 5 - AP',
        'Serviço' => 'E-MAIL / CORREIO ELETRÔNICO',
        'Nível destino' => '2 - SERVIÇOS DE ATENDIMENTO TÉCNICO PRESENCIAL',
        'Por' => 'AP20105 - NERAÍNA LUÍZA CAETANO',
        'Descrição' => '+ Cadastro da Solicitação.'      
      },{
        'Descrição da Solicitação' => '+ Não consigo enviar mensagens com anexo'      
      }
    ])    
  end
  
  private
  
  def file_test(file_name, expected_result)
    page = File.read(File.dirname(__FILE__) + "/" + file_name)
    detalhes = Trf1Sjap::SolicitacaoDetalhes.new(page)
    result = detalhes.updates    
    assert_equal expected_result, result
  end

end
