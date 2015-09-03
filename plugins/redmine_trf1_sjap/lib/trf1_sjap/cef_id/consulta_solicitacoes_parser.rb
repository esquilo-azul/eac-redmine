# encoding: UTF-8

module Trf1Sjap
  module CefId
    class ConsultaSolicitacoesParser
      def initialize(html)
        @html = html
      end

      def solicitacoes
        @solicitacoes ||= begin
          return [] if empty?
          result = []
          rows.each do |row|
            item = {}
            columns.each_with_index { |c, i| item[c] = row[i] }
            result << item
          end
          result
        end
      end

      def empty?
        doc.at_xpath('//span[contains(text(),"CPF não encontrado")]') ? true : false
      end

      private

      def table
        @table ||= doc.at_xpath("id('apl_tabela')/table")
      end

      def doc
        @doc ||= Nokogiri.HTML(@html) { |config| config.options = Nokogiri::XML::ParseOptions::NOBLANKS }
      end

      def sanitize_text(text)
        text.encode('utf-8').strip
      end

      def sanitize_column_name(text)
        sanitize_text(text).match(/^\p{Word}+/).to_s
      end

      def columns
        table.xpath('tr[2]/td/text()').map { |t| sanitize_column_name(t.to_s).parameterize.underscore.to_sym }
      end

      def rows
        table.xpath('tr[position()>2]').map do |row_node|
          row_node.xpath('td').map { |c| cell_value(c) }
        end
      end

      def cell_value(node)
        input = node.at_xpath('input/@value')
        return sanitize_text(input.text) if input && !input.text.strip.empty?
        sanitize_text(node.text)
      end
    end
  end
end
