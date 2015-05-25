# encoding: UTF-8

require File.expand_path('../../../../test_helper', __FILE__)

class Trf1Sjap::EsostiProjectSyncTest < ActiveSupport::TestCase
  def test_parse_solicitacao_user
    assert_equal({
      :login => 'ap20103',
      :firstname => 'Fábio',
      :lastname => 'Júnior Lima do Carmo'
    }, EsostiProjectSync.parse_solicitacao_user('AP20103 - FÁBIO JÚNIOR LIMA DO CARMO'))
  end

end
