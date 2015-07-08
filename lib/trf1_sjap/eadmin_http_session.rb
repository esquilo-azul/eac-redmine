# encoding: UTF-8

require 'nokogiri'
require 'fileutils'

module Trf1Sjap
  class EadminHttpSession
    def initialize usuario, senha, banco='JFAP'
      @httpClient = HTTPClient.new
      @usuario = usuario
      @senha = senha
      @banco = banco
    end

    def login
      begin
        html = request(:post, '/login', {
          'COU_COD_MATRICULA' => @usuario,
          'COU_COD_PASSWORD' => @senha,
          'COU_NM_BANCO' => @banco,
          'Conectar' => 'Conectar',
          :follow_redirect => true
        })
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
      pageContent = request(:get, '/sosti/atendimentosecoes/atendimentousuario')
      log_caixa_atendimento_secao_html(pageContent)
      if !loggedUser?(pageContent) 
        raise UserNotLogged.new
      end
      return CaixaAtendimentoSecao.new(pageContent)
    end
    
    def solicitacao_detalhes(solicitacao_id)
      html = request(:post, '/sosti/detalhesolicitacao/detalhesol',  '{"SSOL_ID_DOCUMENTO":"' + solicitacao_id.to_s + '"}')
      log_solicitacao_detalhes_html(solicitacao_id, html)
      if !loggedUser?(html)
        raise UserNotLogged.new
      end
      return SolicitacaoDetalhes.new(html)
    end

    class UserNotLogged < Exception
    end
    
    private
    
    def log_caixa_atendimento_secao_html(html)
      log_file = "#{Rails.root}/log/esosti_caixa_atendimento_secao/#{@usuario}-#{@banco}.html"
      FileUtils::mkdir_p(File.dirname(log_file))
      File.write(log_file, html)
    end
    
    def log_solicitacao_detalhes_html(solicitacao_id, html)
      log_file = "#{Rails.root}/log/esosti_solicitacao_detalhes/#{solicitacao_id}.html"
      FileUtils::mkdir_p(File.dirname(log_file))
      File.write(log_file, html)
    end

    def concurrency_limit
      @@concurrency_limit ||= Trf1Sjap::ConcurrencyLimit.new(limit)
    end
    
    def limit
      limit = Setting.plugin_redmine_trf1_sjap['eadmin_request_limit'].to_i
      if limit < 1
        limit = 1
      end
      limit
    end

    def request(method, resource, params = {})
      concurrency_limit.process do
        request_without_limit(method, resource, params)
      end
    end

    def request_without_limit(method, resource, params = {})
      url = 'http://sistemas.trf1.jus.br/app/e-Admin' + resource
      if method == :post
        @httpClient.post_content(url, params)
      elsif method == :get
        @httpClient.get_content(url)
      else
        raise 'Unknown method: ' + method.to_s
      end
    end

  end

end