# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap

  class CaixaAtendimentoSecao
    def initialize(pageContent)
      @doc = Nokogiri::HTML(pageContent)
    end

    def solicitacoes
      data = []
      for node in @doc.xpath("id('container_pagination')/table/tbody/tr")
        columns = node.xpath('.//*[string-length(normalize-space(text())) > 0]/text()');
        data.append({
          :numero => columns[0].text.strip,
          :solicitante => columns[2].text.strip,
          :servico_atual => columns[3].text.strip,
          :atendente => __parseAtendente(columns[4].text)
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
      for s in solicitacoes
        if s[:atendente] == ''
        return true
        end
      end
      return false
    end

  end

end