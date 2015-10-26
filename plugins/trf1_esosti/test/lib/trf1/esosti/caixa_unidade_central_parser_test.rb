# encoding: UTF-8

require 'test_helper'

module Trf1
  module Esosti
    class CaixaUnidadeCentralParserTest < ActiveSupport::TestCase
      include Sjap::TestHelpers::Files

      test 'data' do
        assert_files_with_path do |path|
          Trf1::Esosti::CaixaUnidadeCentralParser.new(File.read(path)).data
        end
      end

      def class_file_path
        __FILE__
      end
    end
  end
end
