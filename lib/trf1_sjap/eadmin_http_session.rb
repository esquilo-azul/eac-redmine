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
      return loggedUser?(@httpClient.post_content(uri, body)) != ''
    end

    def loggedUser?(pageContent)
      page = Nokogiri::HTML(pageContent)
      page.xpath("id('nome')/text()[3]").each do |node|
        return node.content.strip
      end
      return ''
    end

    def caixaAtendimentoSecao
      uri = 'http://sistemas.trf1.jus.br/app/e-Admin/sosti/atendimentosecoes/atendimentousuario'
      return @httpClient.get_content(uri)
    end

    def parseCaixaSecaoAtendimento(pageContent)
      return CaixaAtendimentoSecao.new(pageContent).solicitacoesData
    end

    def caixaAtendimentoSecaoSolicitacoes
      return parseCaixaSecaoAtendimento caixaAtendimentoSecao
    end

  end

  class CaixaAtendimentoSecao
    def initialize(pageContent)
      @doc = Nokogiri::HTML(pageContent)
    end

    def solicitacoesData
      data = []
      for node in @doc.xpath("id('container_pagination')/table/tbody/tr")
        data.append({
          :numero => node.at_xpath('td[2]/a/text()').text.strip,
          :solicitante => node.at_xpath('td[4]/text()').text.strip,
          :servico_atual => node.at_xpath('td[5]/text()').text.strip,
          :atendente => __parseAtendente(node.at_xpath('td[6]/text()').text)
        })
      end
      return data
    end

    def __parseAtendente(text)
      text = text.strip
      if text == '-'
        return ''
      else
      return text
      end
    end

    def novaSolicitacao?
      for s in solicitacoesData
        if s[:atendente] == ''
        return true
        end
      end
      return false
    end

  end

end