# encoding: UTF-8

require 'test_helper'

class Trf1Sjap::EsostiRedmineImportTest < ActiveSupport::TestCase
  def test_parse_solicitacao_user
    rotulo_parsed = EsostiUsuario.parse_esosti_usuario_rotulo('AP20103 - FÁBIO JÚNIOR LIMA DO CARMO')
    assert_equal({
                   matricula: 'AP20103',
                   nome: 'FÁBIO JÚNIOR LIMA DO CARMO'
                 }, rotulo_parsed)
    name_parsed = EsostiUsuario.parse_full_name(rotulo_parsed[:nome])
    assert_equal({
                   firstname: 'Fábio',
                   lastname: 'Júnior Lima do Carmo'
                 }, name_parsed)
  end

  def test_parse_solicitacao_user_truncate_middle
    rotulo_parsed = EsostiUsuario.parse_esosti_usuario_rotulo('TR17631PS - LUCIANA DE FREITAS LEITE ANANIAS DA COSTA')
    assert_equal({
                   matricula: 'TR17631PS',
                   nome: 'LUCIANA DE FREITAS LEITE ANANIAS DA COSTA'
                 }, rotulo_parsed)
    name_parsed = EsostiUsuario.parse_full_name(rotulo_parsed[:nome])
    assert_equal({
                   firstname: 'Luciana',
                   lastname: 'de Freitas L. Ananias da Costa'
                 }, name_parsed)
  end

  def test_parse_solicitacao_user_truncate_long_name
    rotulo_parsed = EsostiUsuario.parse_esosti_usuario_rotulo('ABC123DEF - João DE NOMEMUITOLONGOMAIORQUETRINTACARACTERES')
    assert_equal({
                   matricula: 'ABC123DEF',
                   nome: 'João DE NOMEMUITOLONGOMAIORQUETRINTACARACTERES'
                 }, rotulo_parsed)
    name_parsed = EsostiUsuario.parse_full_name(rotulo_parsed[:nome])
    assert_equal({
                   firstname: 'João',
                   lastname: 'de N.'
                 }, name_parsed)
  end
end
