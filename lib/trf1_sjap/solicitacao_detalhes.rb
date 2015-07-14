# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap
  class SolicitacaoDetalhes

    FASE_CADASTRO_DESCRICAO = 'CADASTRO SOLICITAÇÃO TI'
    SOLICITACAO_DESCRICAO_KEY='Descrição da Solicitação'
    AUTOR_ITEM_NOME='Por'
    FASE_ITEM_NOME='Fase'

    def initialize(pageContent)
      @doc = Nokogiri::HTML(pageContent)
    end

    def descricao
      return sanitize_descricao(updates()[0][:itens][SOLICITACAO_DESCRICAO_KEY])
    end

    def updates
      raw_data = parse_updates_raw_data()
      raw_data.reverse!
      raw_data.shift(raw_entry_descricao_solicitacao_index(raw_data))
      # A primeira entrada contém apenas a descrição
      # redigida pelo solicitante.
      raw_data[1].merge!(raw_data[0])
      raw_data.delete_at(0)
      updates = raw_data.map { |entry| UpdateFactory.build(entry) }
      raise 'updates.count <= 0' if updates.count <= 0
      raise "updates[0][:fase_descricao] != FASE_CADASTRO_DESCRICAO (\"#{updates[0][:fase]}\")" if updates[0][:fase] != SolicitacaoDetalhes::FASE_CADASTRO_DESCRICAO
      updates
    end

    def parse_updates_raw_data
      data = []
      for container in updates_containers()
        update_consumer = UpdateConsumer.new
        update_data(container, update_consumer)
        data << update_consumer.to_hash
      end
      return data
    end
    
    def parse_properties_raw_data
      tbody = @doc.at_xpath("id('tabs-1')/table")
      raise 'TBODY not found' if !tbody
      PropertiesParser.new(tbody).properties
    end

    # Extrai a descrição da fase e a data/hora que aparecem
    # no item "Fase" das atualizações de solicitação e-Sosti.
    def self.parse_fase(input)
      parts = /(.+)(\d{2}\/\d+\/\d+\s+\d+\:\d+\:\d+)/.match(input)
      if parts == nil
        raise "Não foi possível analisar \"#{input}\""
      end
      return [parts[1].strip, DateTime.strptime(parts[2],'%d/%m/%Y %H:%M:%S')]
    end

    private
    
    # Procura pela entrada que contém a descrição da solicitação
    def raw_entry_descricao_solicitacao_index(raw_data_entries)
      raw_data_entries.each_with_index do |value, index|
        if value.has_key?(SOLICITACAO_DESCRICAO_KEY)
          return index          
        end
      end
      raise '\"' + SOLICITACAO_DESCRICAO_KEY + '\" não foi encontrada'
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
    
    def self.build(update_entries)
      if ! update_entries.has_key?(SolicitacaoDetalhes::FASE_ITEM_NOME)
        raise "Entrada de solicitação e-Sosti não tem propriedade \"#{SolicitacaoDetalhes::FASE_ITEM_NOME}\" (" + update_entries.to_s + ")"
      end      
      fase_descricao, fase_data = SolicitacaoDetalhes.parse_fase(update_entries[SolicitacaoDetalhes::FASE_ITEM_NOME])
      return {
        :data_hora => fase_data,
        :fase => fase_descricao,
        :itens => update_entries
      }
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
  
  class PropertiesParser
    
    attr_reader :properties
    
    def initialize(tbody)
      @properties = {}
      [
        SameParser.new('Solicitação Nº' , tbody),
        SameParser.new('Data da Solicitação', tbody),
        RightParser.new('Unidade Solicitante' , tbody),
        RightParser.new('Nome do Solicitante', tbody),
        RightParser.new('Matricula', tbody),
        RightParser.new('E-mail do Solicitante', tbody),
        RightParser.new('Telefone', tbody),
        RightParser.new('Local de Atendimento', tbody),
        RightParser.new('Serviço Atual', tbody),
        BelowParser.new('Descrição', tbody),
        BelowParser.new('Observação', tbody),
        BelowParser.new('Encaminhado para', tbody)
      ].each {|p| @properties[p.name] = p.value}      
    end
    
    class AbstractParser
      
      attr_reader :name
      
      def initialize(name, tbody)
        @name = name
        @tbody = tbody
      end
      
      def name_cell
        for tag in ['td','th']
          cell = @tbody.at_xpath('//' + tag + '[contains(text(), "' + @name + '")]')
          return cell if cell
        end
        raise "Name cell not found (Name: \"#{@name}\")"
      end
      
      def value
        sub_value.gsub("\r", '').strip
      end
      
    end
    
    class SameParser < AbstractParser      
      def sub_value
        name_cell.text.sub(@name + ':', '')
      end
    end
    
    class RightParser < AbstractParser 
      def sub_value
        name_cell.next_element.text
      end
    end
    
    class BelowParser < AbstractParser
      def sub_value
        name_cell.parent.next_element.at_xpath('td').text
      end
    end
    
  end
  

end