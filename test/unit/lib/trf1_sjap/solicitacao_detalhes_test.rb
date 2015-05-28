# encoding: UTF-8

require File.expand_path('../../../../test_helper', __FILE__)

class Trf1Sjap::SolicitacaoDetalhesTest < ActiveSupport::TestCase
  def test_descricao
    file_test(:descricao,
      'solicitacao-detalhes_817986_2015-05-25_12-50-00.html',
      'Não consigo enviar mensagens com anexo'
    )
    file_test(:descricao,
      'solicitacao-detalhes_815452.html',
      'Problemas na impressão'
    )
  end

  def test_parse_raw_data
    file_test(:parse_raw_data, 'solicitacao-detalhes_817986_2015-05-25_12-50-00.html', [{
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
    file_test(:parse_raw_data, 'solicitacao-detalhes_815452.html', [{
        'Fase' => 'AVALIAÇÃO DE SERVIÇO DE TI 22/05/2015 11:13:18 2D 0h 11m 49s',
        'Avaliação' => 'ÓTIMO',
        'Por' => 'AP7903 - GRACIETE LOBATO VIDAL'
      },{ 
        'Fase' => 'BAIXA SOLICITAÇÃO TI 20/05/2015 15:52:27 0D 4h 50m 57s',
        'Por' => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR',
        'Tombo' => '7436 - IMPRESSORA SAMSUNG ML-3750-ND.',
        'Descrição' => '+ serviço concluido.'
      },{
        'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 20/05/2015 11:01:58 0D 0h 0m 29s',
        'Por' => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR',
        'Tombo' => '7436 - IMPRESSORA SAMSUNG ML-3750-ND.',
        'Descrição' => '+ Em atendimento.'
      },{
        'Fase' => 'CADASTRO SOLICITAÇÃO TI 20/05/2015 11:01:29 0D 0h 0m 0s',
        'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): SEÇÃO JUDICIÁRIA DO AMAPÁ - 5 - AP',
        'Serviço' => 'IMPRESSORA',
        'Nível destino' => '2 - SERVIÇOS DE ATENDIMENTO TÉCNICO PRESENCIAL',
        'Por' => 'AP7903 - GRACIETE LOBATO VIDAL',
        'Tombo' => '7436 - IMPRESSORA SAMSUNG ML-3750-ND.',
        'Descrição' => '+ Cadastro da Solicitação.'
      },{
        'Descrição da Solicitação' => '+ Problemas na impressão'
      }])
  end
  
  private
  
  def file_test(method, file_name, expected_result)
    page = File.read(File.dirname(__FILE__) + "/" + file_name)
    detalhes = Trf1Sjap::SolicitacaoDetalhes.new(page)
    result = detalhes.send(method)
    assert_equal expected_result, result
  end

end
