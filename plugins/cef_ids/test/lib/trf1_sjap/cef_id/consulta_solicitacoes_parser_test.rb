# encoding: UTF-8

require 'test_helper'

module Trf1Sjap
  module CefId
    class ConsultaSolicitacoesParserTest < ActiveSupport::TestCase
      include Trf1Sjap::TestHelpers::Files

      test 'parser' do
        assert_files_with_path do |path|
          ConsultaSolicitacoesParser.new(File.read(path).force_encoding('utf-8')).solicitacoes
        end
      end

      def files_directory
        File.expand_path('../../../../fixtures/trf1_sjap/cef_id/consulta_solicitacoes_parser_test_files', __FILE__)
      end
    end
  end
end
