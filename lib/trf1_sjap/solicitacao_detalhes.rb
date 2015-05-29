# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap
  class SolicitacaoDetalhes
    def initialize(pageContent)
      @doc = Nokogiri::HTML(pageContent)
    end

    def descricao
      return sanitize_descricao(parse_raw_data()[0].first[1])
    end

    def updates
      raw_data = parse_raw_data()
      raw_data.reverse!
      raw_data.shift(raw_entry_descricao_solicitacao_index(raw_data))
      # A primeira entrada contém apenas a descrição
      # redigida pelo solicitante.
      raw_data[1].merge!(raw_data[1])
      raw_data.delete_at(0)
      raw_data.map { |entry| UpdateFactory.build(entry) }      
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
    
    # Procura pela entrada que contém a descrição da solicitação
    def raw_entry_descricao_solicitacao_index(raw_data_entries)
      raw_data_entries.each_with_index do |value, index|
        if value.has_key?('Descrição da Solicitação')
          return index          
        end
      end
      raise '\"Descrição da Solicitação\" não foi encontrada'
    end

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
          update_consumer.addText(node.parent.name, text)
        end
      end
      if node.kind_of?(Nokogiri::XML::Element) && ! ['fieldset', 'a'].include?(node.name) 
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

  class UpdateFactory
    
    @@fase_descricao_mapping = {
      'CADASTRO SOLICITAÇÃO TI' => :cadastro,
      'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL' => :encaminhamento_caixa_pessoal,
      'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI ENTRE GRUPOS DA MESMA SEÇÃO' => :encaminhamento_intra_secao,
      'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI DE SEÇÃO PARA O TRIBUNAL' => :encaminhamento_tribunal,
      'ENCAMINHAMENTO DE SOLICITAÇÃO ENTRE GRUPOS DO TRF1' => :encaminhamento_intra_tribunal,
      'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI DO TRIBUNAL PARA SEÇÃO' => :encaminhamento_secao,
      'PEDIDO DE INFORMAÇÃO PARA SOLICITAÇÃO À TI' => :pedido_informacao,
      'SOLICITAÇÃO DE EXTENSÃO DE PRAZO PARA SOLICITAÇÃO DE TI' => :pedido_extensao_prazo,
      'DEVOLUÇÃO DE SOLICITAÇÃO DE TI' => :devolucao,
      'CANCELAMENTO DE SOLICITAÇÃO' => :cancelamento,
      'BAIXA SOLICITAÇÃO TI' => :baixa,
      'AVALIAÇÃO DE SERVIÇO DE TI' => :avaliacao_aceita,
      'AVALIAÇÃO DE SERVIÇO DE TI RECUSADA' => :avaliacao_recusada,
      'DAR PARECER NA SOLICITAÇÃO DE TI' => :parecer
    }
    
    def self.build(update_entries)
      if ! update_entries.has_key?('Fase')
        raise "Entrada de solicitação e-Sosti não tem propriedade \"Fase\" (" + update_entries.to_s + ")"
      end      
      fase_descricao, fase_data = parse_fase(update_entries['Fase'])
      if ! @@fase_descricao_mapping.has_key?(fase_descricao)
        raise "Mapeamento não encontrado para \"#{fase_descricao}\""
      end
      return {
        :tipo => @@fase_descricao_mapping[fase_descricao],
        :date => fase_data,
        :descricao => fase_descricao
      }
    end

    def self.parse_fase(input)
      parts = /(.+)(\d{2}\/\d+\/\d+\s+\d+\:\d+\:\d+)/.match(input)
      if parts == nil
        raise "Não foi possível analisar \"#{input}\""
      end
      return [parts[1].strip, DateTime.strptime(parts[2],'%d/%m/%Y %H:%M:%S')]
    end

  end

  class UpdateConsumer
    def initialize
      @properties = []
      @closed_label = false
      @current_value = true
    end

    def addText(tag_name, text)
      if text.kind_of?(Array)
        add_text_unit(tag_name, text.join(' '))
      elsif text.kind_of?(String)
        add_text_unit(tag_name, text)
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
    
    def add_text_unit(tag_name, text)
      if tag_name == 'b' && (!@label_closed || text.strip.end_with?(':') )
        if m = /(.+)\:(.+)/.match(text)
          add_label_text(m[1])
          add_value_text(m[2])
        else
          add_label_text(text)
        end
        #if m = /Nome Documento\:\s(.+)/.match(text)
        #  
        #else
        #  add_label_text(text)
        #end
                 
      else
        add_value_text(text) 
      end
    end

    def add_label_text(text)
      if @current_value || text.strip.end_with?(':')
        @properties << {:key => '', :value => ''}
      end
      if @properties.length == 0
        raise "Nenhuma chave de propriedade foi adicionada (Text: \"#{text}\")"
      end
      @properties[-1][:key] += ' ' + text
      @closed_label = 
      @current_value = false 
    end

    def add_value_text(text)
      if @properties.length == 0
        raise "Nenhuma chave de propriedade foi adicionada (Text: \"#{text}\")"
      end
      @properties[-1][:value] += ' ' + text
      @closed_label = false
      @current_value = true
    end

    def sanitize_key(k)
      return sanitize_value(k).chomp(':')
    end

    def sanitize_value(v)
      return v.gsub(/\p{Space}+/,' ').strip
    end

  end

end