# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap
  class SolicitacaoDetalhes
    FASE_CADASTRO_DESCRICAO = 'CADASTRO SOLICITAÇÃO TI'
    SOLICITACAO_DESCRICAO_KEY = 'Descrição da Solicitação'
    AUTOR_ITEM_NOME = 'Por'
    FASE_ITEM_NOME = 'Fase'

    def initialize(pageContent)
      @doc = Nokogiri::HTML(pageContent, &:noblanks)
    end

    def descricao
      sanitize_descricao(updates[0][:itens][SOLICITACAO_DESCRICAO_KEY])
    end

    def updates
      raw_data = parse_updates_raw_data
      raw_data.reverse!
      raw_data.shift(raw_entry_descricao_solicitacao_index(raw_data))
      # A primeira entrada contém apenas a descrição
      # redigida pelo solicitante.
      raw_data[1].merge!(raw_data[0])
      raw_data.delete_at(0)
      updates = raw_data.map { |entry| UpdateFactory.build(entry) }
      fail 'updates.count <= 0' if updates.count <= 0
      fail "updates[0][:fase_descricao] != FASE_CADASTRO_DESCRICAO (\"#{updates[0][:fase]}\")" if updates[0][:fase] != SolicitacaoDetalhes::FASE_CADASTRO_DESCRICAO
      updates
    end

    def parse_updates_raw_data
      data = []
      for container in updates_containers
        update_consumer = UpdateConsumer.new
        update_data(container, update_consumer)
        data << update_consumer.to_hash
      end
      data
    end

    def propriedades
      parse_properties_raw_data
    end

    def parse_properties_raw_data
      tbody = @doc.at_xpath("id('tabs-1')/table")
      fail 'TBODY not found' unless tbody
      PropertiesParser.new(tbody).properties
    end

    # Extrai a descrição da fase e a data/hora que aparecem
    # no item "Fase" das atualizações de solicitação e-Sosti.
    def self.parse_fase(input)
      parts = /(.+)(\d{2}\/\d+\/\d+\s+\d+\:\d+\:\d+)/.match(input)
      fail "Não foi possível analisar \"#{input}\"" if parts.nil?
      [parts[1].strip, DateTime.strptime(parts[2], '%d/%m/%Y %H:%M:%S')]
    end

    private

    # Procura pela entrada que contém a descrição da solicitação
    def raw_entry_descricao_solicitacao_index(raw_data_entries)
      raw_data_entries.each_with_index do |value, index|
        return index if value.key?(SOLICITACAO_DESCRICAO_KEY)
      end
      fail '\"' + SOLICITACAO_DESCRICAO_KEY + '\" não foi encontrada'
    end

    def updates_containers
      containers = []
      for fieldset in @doc.xpath("id('tabs-2')//fieldset")
        containers << fieldset.at_xpath('div')
      end
      containers
    end

    def update_data(node, update_consumer)
      if node.is_a?(Nokogiri::XML::Text)
        text = node.text.split
        update_consumer.addText(node.parent.name, text) if text.length > 0
      end
      if node.is_a?(Nokogiri::XML::Element) && ! %w(fieldset a).include?(node.name)
        for child in node.children
          update_data(child, update_consumer)
        end
      end
    end

    def sanitize_descricao(string)
      a = string.clone
      a.slice!('+')
      a.strip
    end
  end

  class UpdateFactory
    def self.build(update_entries)
      unless update_entries.key?(SolicitacaoDetalhes::FASE_ITEM_NOME)
        fail "Entrada de solicitação e-Sosti não tem propriedade \"#{SolicitacaoDetalhes::FASE_ITEM_NOME}\" (" + update_entries.to_s + ')'
      end
      fase_descricao, fase_data = SolicitacaoDetalhes.parse_fase(update_entries[SolicitacaoDetalhes::FASE_ITEM_NOME])
      {
        data_hora: fase_data,
        fase: fase_descricao,
        itens: update_entries
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
      if text.is_a?(Array)
        add_text_unit(tag_name, text.join(' '))
      elsif text.is_a?(String)
        add_text_unit(tag_name, text)
      else
        fail 'Parâmetro text não é uma string ou array'
      end
    end

    def to_hash
      hash = {}
      for p in @properties
        hash[sanitize_key(p[:key])] = sanitize_value(p[:value])
      end
      hash
    end

    private

    def add_text_unit(tag_name, text)
      if tag_name == 'b' && (!@label_closed || text.strip.end_with?(':'))
        if m = /(.+)\:(.+)/.match(text)
          add_label_text(m[1])
          add_value_text(m[2])
        else
          add_label_text(text)
        end
        # if m = /Nome Documento\:\s(.+)/.match(text)
        #
        # else
        #  add_label_text(text)
        # end

      else
        add_value_text(text)
      end
    end

    def add_label_text(text)
      if @current_value || text.strip.end_with?(':')
        @properties << { key: '', value: '' }
      end
      if @properties.length == 0
        fail "Nenhuma chave de propriedade foi adicionada (Text: \"#{text}\")"
      end
      @properties[-1][:key] += ' ' + text
      @closed_label =
      @current_value = false
    end

    def add_value_text(text)
      if @properties.length == 0
        fail "Nenhuma chave de propriedade foi adicionada (Text: \"#{text}\")"
      end
      @properties[-1][:value] += ' ' + text
      @closed_label = false
      @current_value = true
    end

    def sanitize_key(k)
      sanitize_value(k).chomp(':')
    end

    def sanitize_value(v)
      v.gsub(/\p{Space}+/, ' ').strip
    end
  end

  class PropertiesParser
    LABELS_SKIP = ['Guia para Atendimento Presencial']
    attr_reader :properties

    def initialize(tbody)
      @properties = {}
      get_all_label_cells(tbody).each do |label_cell|
        parser = ParserFactory.get_parser(label_cell)
        @properties[parser.name] = parser.value unless LABELS_SKIP.include?(parser.name)
      end
    end

    def self.normalize_text(text)
      text.gsub("\r|\n|\r\n", ' ').split.join(' ').gsub(/^\p{Space}*/, '').gsub(/\p{Space}*$/, '')
    end

    private

    def get_all_label_cells(tbody)
      cells = []
      cells << get_label_cell_by_name(tbody, 'Solicitação Nº')
      cells << get_label_cell_by_name(tbody, 'Data da Solicitação')
      cells.concat tbody.xpath('//th')
    end

    def get_label_cell_by_name(tbody, name)
      for tag in %w(td th)
        cell = tbody.at_xpath('//' + tag + '[contains(text(), "' + name + '")]')
        return cell if cell
      end
      nil
    end

    class ParserFactory
      def self.get_parser(label_cell)
        if label_cell.name == 'td'
          return SameParser.new(label_cell)
        elsif label_cell.name == 'th'
          if label_cell.parent.children.count { |c| c.is_a?(Nokogiri::XML::Element) } == 1
            return BelowParser.new(label_cell)
          else
            return RightParser.new(label_cell)
          end
        end
      end
    end

    class AbstractParser
      attr_reader :cell_label

      def initialize(cell_label)
        @label_cell = cell_label
      end

      def name
        PropertiesParser.normalize_text(@label_cell.text.sub(':', ''))
      end
    end

    class SameParser < AbstractParser
      def value
        PropertiesParser.normalize_text(@label_cell.text.sub(name + ':', ''))
      end

      def name
        PropertiesParser.normalize_text(/^([^:]+)/.match(@label_cell.text)[1])
      end
    end

    class RightParser < AbstractParser
      def value
        PropertiesParser.normalize_text(@label_cell.next_element.text)
      end
    end

    class BelowParser < AbstractParser
      def value
        PropertiesParser.normalize_text(@label_cell.parent.next_element.at_xpath('td').text)
      end
    end
  end
end
