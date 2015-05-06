# encoding: UTF-8

require File.expand_path('../../../../test_helper', __FILE__)

class Trf1Sjap::EsostiHttpSessionTest < ActiveSupport::TestCase
  def test_parse_caixa_atendimento_secao
    session = Trf1Sjap::EadminHttpSession.new('ap123456','123456')
    page = File.read(File.dirname(__FILE__) + "/caixa-2015-05-06_08-23-55.html")
    result = session.parseCaixaSecaoAtendimento(page)
    expected = [
      {
        'numero' => '2015/AP/SEINF/71',
        'solicitante' => 'AP20199 - EDUARDO HENRIQUE BOGONI',
        'servico_atual' => 'CONFIGURAÇÃO INTERNET',
        'atendente' => ''
      },{
        'numero' => '2015/AP/SEVIT/24',
        'solicitante' => 'AP5103 - GERALDO MAGELA ROCHA',
        'servico_atual' => 'CONFIGURAÇÃO DE EQUIPAMENTO',
        'atendente' => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR'
      },{
        'numero' => '2015/AP/SAD/28',
        'solicitante' => 'AP20188 - NAIANNA DA FONSECA CARNEIRO',
        'servico_atual' => 'INSTALAÇÃO DE PROGRAMAS E APLICATIVOS',
        'atendente' => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR'
      },{
        'numero' => '2015/AP-LJI/SEPOD-VARA1/8',
        'solicitante' => 'AP20060 - JOAQUIM DA SILVA OLIVEIRA',
        'servico_atual' => 'JEF VIRTUAL - DOCUMENTOS',
        'atendente' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS'
      }
    ]
    assert_equal expected, result
  end

end
