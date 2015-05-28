# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap
  class SolicitacaoDetalhes
    def initialize(pageContent)
      @doc = Nokogiri::HTML(pageContent)
    end

    def descricao
      return sanitize_descricao(parse_raw_data()[-1].first[1])
    end

    def parse_raw_data
      data = []
      for container in updates_containers()
        update_consumer = UpdateConsumer.new
        update_data(container, update_consumer)
        data << update_consumer.to_hash
      end
      return data
    end

    private

    def updates_containers
      containers = []
      for fieldset in @doc.xpath("id('tabs-2')//fieldset")
        containers << fieldset.at_xpath('div')
      end
      return containers
    end

    def update_data(node, update_consumer)
      if node.kind_of?(Nokogiri::XML::Text)
        text = node.text.split
        if text.length > 0
          update_consumer.addText(node.parent.name == 'b', text)
        end
      end
      if node.kind_of?(Nokogiri::XML::Element) && node.name != 'fieldset'
        for child in node.children
          update_data(child, update_consumer)
        end
      end
    end
    
    def sanitize_descricao(string)
      a = string.clone
      a.slice!('+')
      return a.strip
    end

  end

  class UpdateConsumer
    def initialize
      @properties = []
      @onbold = false
    end

    def addText(is_bold, text)
      if text.kind_of?(Array)
        text.map{ |t| addText(is_bold, t) }
      elsif text.kind_of?(String)
        if is_bold
          addBold(text)
        else
          addNormal(text)
        end
      else
        raise "Parâmetro text não é uma string ou array"
      end
    end

    def to_hash
      hash = {}
      for p in @properties
        hash[sanitize_key(p[:key])] = sanitize_value(p[:value])
      end
      return hash
    end

    private

    def addBold(text)
      if ! @onbold
        @properties << {:key => '', :value => ''}
        @onbold = true
      end
      @properties[-1][:key] += ' ' + text
    end

    def addNormal(text)
      if @properties.length == 0
        raise "Nenhuma chave de propriedade foi adicionada (Text: \"#{text}\")"
      end
      @onbold = false
      @properties[-1][:value] += ' ' + text
    end

    def sanitize_key(k)
      return sanitize_value(k).chomp(':')
    end

    def sanitize_value(v)
      return v.gsub(/\p{Space}+/,' ').strip
    end

  end

end