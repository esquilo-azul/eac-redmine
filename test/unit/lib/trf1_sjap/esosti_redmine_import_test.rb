# encoding: UTF-8

require File.expand_path('../../../../test_helper', __FILE__)

class Trf1Sjap::EsostiRedmineImportTest < ActiveSupport::TestCase
  def test_parse_solicitacao_user
    assert_equal({
      :login => 'ap20103',
      :firstname => 'Fábio',
      :lastname => 'Júnior Lima do Carmo'
    }, Trf1Sjap::EsostiRedmineImport::UpdateToRedmine.parse_solicitacao_user('AP20103 - FÁBIO JÚNIOR LIMA DO CARMO'))
  end
  
  def test_parse_solicitacao_user_truncate_middle
    assert_equal({
      :login => 'tr17631ps',
      :firstname => 'Luciana',
      :lastname => 'de Freitas L. Ananias da Costa'      
    }, Trf1Sjap::EsostiRedmineImport::UpdateToRedmine.parse_solicitacao_user('TR17631PS - LUCIANA DE FREITAS LEITE ANANIAS DA COSTA'))
  end
  
  def test_parse_solicitacao_user_truncate_long_name
    assert_equal({
      :login => 'abc123def',
      :firstname => 'João',
      :lastname => 'de N.'      
    }, Trf1Sjap::EsostiRedmineImport::UpdateToRedmine.parse_solicitacao_user('ABC123DEF - João DE NOMEMUITOLONGOMAIORQUETRINTACARACTERES'))
  end
  
  def test_parse_solicitacao_descricao
    assert_equal(
      'Favor instalar +1 computador tipo 2 para o servidor Marco Antonio Rodrigues Lima - AP20191', 
      Trf1Sjap::EsostiRedmineImport::UpdateToRedmine.parse_solicitacao_descricao(' + Favor instalar +1 computador tipo 2 para o servidor Marco Antonio Rodrigues Lima - AP20191 ')
    )
  end

end