# encoding: UTF-8

require 'test_helper'
module Sjap
  module Ponto
    module SuperFacil
      class AfdRegistroParserTest < ActiveSupport::TestCase
        def test_parse_line
          samples = {
            '0000543403140420151509013143342608' => {
              nsr: '000054340', tipo: '3', data: '14042015', horario: '1509', pis: '013143342608'
            },
            '0000543365140420151507I013143342608Eduardo Henrique Bogoni' => {
              nsr: '000054336', tipo: '5', gravacao_data: '14042015', gravacao_hora: '1507',
              operacao: 'I', pis: '013143342608', nome: 'Eduardo Henrique Bogoni'
            },
            '0000543385140420151508A013143342608Eduardo Henrique Bogoni' => {
              nsr: '000054338', tipo: '5', gravacao_data: '14042015', gravacao_hora: '1508',
              operacao: 'A', pis: '013143342608', nome: 'Eduardo Henrique Bogoni'
            },
            '0000543395140420151509A013143342608Eduardo Henrique Bogoni' => {
              nsr: '000054339', tipo: '5', gravacao_data: '14042015', gravacao_hora: '1509',
              operacao: 'A', pis: '013143342608', nome: 'Eduardo Henrique Bogoni'
            },
            '0000113975020720141456A012780367034Claudio Renan da Costa Dias' => {
              nsr: '000011397', tipo: '5', gravacao_data: '02072014', gravacao_hora: '1456',
              operacao: 'A', pis: '012780367034', nome: 'Claudio Renan da Costa Dias'
            },
            '0000113733020720141206020912762106' => {
              nsr: '000011373', tipo: '3', data: '02072014', horario: '1206', pis: '020912762106'
            },
            '0000001875300420141352A012346010083Amarildo Dias da Silva' => {
              nsr: '000000187', tipo: '5', gravacao_data: '30042014', gravacao_hora: '1352',
              operacao: 'A', pis: '012346010083', nome: 'Amarildo Dias da Silva'
            },
            '0000001883300420141352012346010083' => {
              nsr: '000000188', tipo: '3', data: '30042014', horario: '1352', pis: '012346010083'
            }
          }
          samples.each do |k, v|
            assert_equal v, Sjap::Ponto::Mte::AfdRegistroParser.parse_line(k)
          end
        end

        def test_parse_all
          File.read(parse_all_input_path, encoding: 'ISO-8859-1').each_line do |line|
            r = Sjap::Ponto::Mte::AfdRegistroParser.parse_line(line)
            assert Sjap::Ponto::Mte::AfdRegistroParser::TIPOS.keys.include?(r[:tipo])
          end
        end

        def parse_all_input_path
          File.expand_path('../../../../fixtures/rep_00004001900023539.txt', File.dirname(__FILE__))
        end
      end
    end
  end
end
