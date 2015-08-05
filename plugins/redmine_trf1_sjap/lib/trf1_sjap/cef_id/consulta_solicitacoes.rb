#!/usr/bin/env ruby
# encoding: UTF-8

require 'httpclient'
require 'nokogiri'

module Trf1Sjap
  module CefId
    class ConsultaSolicitacoes
      attr_reader :cpf

      def initialize(cpf)
        @cpf = cpf
        @fetch_result = nil
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

      def html
        @html ||= fetch.body
      end

      def table
        @table ||= doc.at_xpath("id('apl_tabela')/table")
      end

      def doc
        @doc ||= Nokogiri.HTML(html)  { |config| config.options = Nokogiri::XML::ParseOptions::NOBLANKS }
      end

      def fetch
        if @fetch_result.nil?
          http_client = HTTPClient.new
          http_client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
          url = 'https://certificadodigital.caixa.gov.br/cefar/consulta/consulta/consulta.htm'
          @fetch_result = http_client.post(url, 'numeroCpf' => @cpf)
        end
        @fetch_result
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
          row_node.xpath('td').map { |c| sanitize_text(c.text) }
        end
      end
    end
  end
end
