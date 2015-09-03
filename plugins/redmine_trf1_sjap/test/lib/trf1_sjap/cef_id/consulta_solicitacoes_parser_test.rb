# encoding: UTF-8

require 'test_helper'
require_relative '../../../file_test_helper'

module Trf1Sjap
  module CefId
    class ConsultaSolicitacoesParserTest < ActiveSupport::TestCase
      include FileTestHelper

      def source_content_to_value(html)
        ConsultaSolicitacoesParser.new(html.force_encoding('utf-8')).solicitacoes
      end
    end
  end
end
