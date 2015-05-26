# encoding: UTF-8

require File.expand_path('../../../../test_helper', __FILE__)

class Trf1Sjap::CaixaAtendimentoSecaoTest < ActiveSupport::TestCase
  def test_parse_caixa_atendimento_secao
    file_test('caixa-2015-05-06_08-23-55.html', [
      {
        :id => 806854,
        :numero => '2015/AP/SEINF/71',
        :solicitante => 'AP20199 - EDUARDO HENRIQUE BOGONI',
        :servico_atual => 'CONFIGURAÇÃO INTERNET',
        :atendente => ''
      },{
        :id => 806722,
        :numero => '2015/AP/SEVIT/24',
        :solicitante => 'AP5103 - GERALDO MAGELA ROCHA',
        :servico_atual => 'CONFIGURAÇÃO DE EQUIPAMENTO',
        :atendente => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR'
      },{
        :id => 806384,
        :numero => '2015/AP/SAD/28',
        :solicitante => 'AP20188 - NAIANNA DA FONSECA CARNEIRO',
        :servico_atual => 'INSTALAÇÃO DE PROGRAMAS E APLICATIVOS',
        :atendente => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR'
      },{
        :id => 749708,
        :numero => '2015/AP-LJI/SEPOD-VARA1/8',
        :solicitante => 'AP20060 - JOAQUIM DA SILVA OLIVEIRA',
        :servico_atual => 'JEF VIRTUAL - DOCUMENTOS',
        :atendente => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS'
      }
    ])
    file_test('caixa-2015-05-20-12-00-00.html', [
      {
        :id => 815452,
        :numero => '2015/AP/SEPCE/25',
        :solicitante => 'AP7903 - GRACIETE LOBATO VIDAL',
        :servico_atual => 'IMPRESSORA',
        :atendente => 'RONALDO DIAS CARDOSO JUNIOR'
      },{
        :id => 815445,
        :numero => '2015/AP/SESUD-6ª VARA/12',
        :solicitante => 'AP20121 - CARLOS HAILTON GOMES DOS SANTOS',
        :servico_atual => 'INSTALAÇÃO DE PROGRAMAS E APLICATIVOS',
        :atendente => 'RONALDO DIAS CARDOSO JUNIOR'
      }
    ])
    file_test('caixa-2015-05-20_16-18-00.html', [
      {
        :id => 815949,
        :numero => '2015/AP/SEINF/83',
        :solicitante => 'AP20199 - EDUARDO HENRIQUE BOGONI',
        :servico_atual => 'ACESSO REMOTO - TS',
        :atendente => ''
      },{
        :id => 815916,
        :numero => '2015/AP/GAJUS-2ª VARA/22',
        :solicitante => 'AP20129 - TIAGO FELIPE MENEZES SOARES',
        :servico_atual => 'CONFIGURAÇÃO INTERNET',
        :atendente => 'RONALDO DIAS CARDOSO JUNIOR'
      },{
        :id => 815844,
        :numero => '2015/AP/SEDAJ/42',
        :solicitante => 'AP20066 - LEONARDO GOMES DOS REIS',
        :servico_atual => 'SUBSTITUIÇÃO DE CARTUCHO',
        :atendente => 'RONALDO DIAS CARDOSO JUNIOR'
      },{
        :id => 815839,
        :numero => '2015/AP/SECVA-2ª VARA/21',
        :solicitante => 'AP20145 - TERCIO FEITOZA DE ARAUJO',
        :servico_atual => 'INSTALAÇÃO DE PROGRAMAS E APLICATIVOS',
        :atendente => 'RONALDO DIAS CARDOSO JUNIOR'
      },{
        :id => 815735,
        :numero => '2015/AP/SECVA-2ª VARA/20',
        :solicitante => 'AP20145 - TERCIO FEITOZA DE ARAUJO',
        :servico_atual => 'INSTALAÇÃO DE PROGRAMAS E APLICATIVOS',
        :atendente => 'RONALDO DIAS CARDOSO JUNIOR'
      },{
        :id => 815703,
        :numero => '2015/AP/SEXEC-1ª VARA/8',
        :solicitante => 'AP17003 - ROGÉRIO BEZERRA DA COSTA',
        :servico_atual => 'CONFIGURAÇÃO INTERNET',
        :atendente => 'RONALDO DIAS CARDOSO JUNIOR'
      }
    ])
  end
  
  private
  
  def file_test(file_name, expected_result)
    page = File.read(File.dirname(__FILE__) + "/" + file_name)
    caixa = Trf1Sjap::CaixaAtendimentoSecao.new(page)
    result = caixa.solicitacoes    
    assert_equal expected_result, result
  end

end
