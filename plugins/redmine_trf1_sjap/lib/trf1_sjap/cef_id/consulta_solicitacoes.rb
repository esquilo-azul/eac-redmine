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
      end

      def solicitacoes
        parser.solicitacoes
      end

      private

      def html
        @html ||= begin
          body = fetch.body
          log_consulta(body)
          body
        end
      end
      
      def parser 
        ConsultaSolicitacoesParser.new(html)
      end

      def fetch
        @fetch_result ||= begin
          http_client = HTTPClient.new
          http_client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
          url = 'https://certificadodigital.caixa.gov.br/cefar/consulta/consulta/consulta.htm'
          http_client.post(url, 'numeroCpf' => @cpf)
        end        
      end

      def log_consulta(html)
        log_file = "#{Rails.root}/log/cef_id_consulta_solicitacoes/#{cpf}.html"
        FileUtils::mkdir_p(File.dirname(log_file))
        File.write(log_file, html)
      end
    end
  end
end
