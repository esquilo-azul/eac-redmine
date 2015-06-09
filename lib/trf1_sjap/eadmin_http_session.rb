# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap
  class EadminHttpSession
    def initialize usuario, senha, banco='JFAP'
      @httpClient = HTTPClient.new
      @usuario = usuario
      @senha = senha
      @banco = banco
    end

    def login
      uri = 'http://sistemas.trf1.jus.br/app/e-Admin/login'
      body = { 'COU_COD_MATRICULA' => @usuario,
        'COU_COD_PASSWORD' => @senha,
        'COU_NM_BANCO' => @banco,
        'Conectar' => 'Conectar',
        :follow_redirect => true
      }
      begin
        html = @httpClient.post_content(uri, body)
      rescue SocketError, HTTPClient::BadResponseError, HTTPClient::TimeoutError => ex
        return ex.class.name + ': ' + ex.message
      end
      if loggedUser?(html)
        return true
      end
      doc = Nokogiri::HTML(html)
      errorNode = doc.at_xpath("id('conteudoLogin')/div[1]/text()")
      if errorNode != nil
      	return errorNode.text.strip
      end
      return 'Erro desconhecido'
    end

    def loggedUser?(pageContent)
      page = Nokogiri::HTML(pageContent)
      page.xpath("id('nome')/text()[3]").each do |node|
        return node.content.strip
      end
      return false
    end

    def caixaAtendimentoSecao
      pageContent = @httpClient.get_content('http://sistemas.trf1.jus.br/app/e-Admin/sosti/atendimentosecoes/atendimentousuario')
      if !loggedUser?(pageContent) 
        raise UserNotLogged.new
      end
      return CaixaAtendimentoSecao.new(pageContent)
    end
    
    def solicitacao_detalhes(solicitacao_id)
      uri = 'http://sistemas.trf1.jus.br/app/e-Admin/sosti/detalhesolicitacao/detalhesol'
      body = '{"SSOL_ID_DOCUMENTO":"' + solicitacao_id.to_s + '"}'
      html = @httpClient.post_content(uri, body)
      if !loggedUser?(html)
        raise UserNotLogged.new
      end
      return SolicitacaoDetalhes.new(html)
    end

    class UserNotLogged < Exception
    end

  end

end