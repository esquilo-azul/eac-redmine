# encoding: UTF-8

require 'test_helper'
module Sjap
  module Ponto
    module SuperFacil
      class PontoParserTest < ActiveSupport::TestCase
        def test_parse_line
          samples = {
            '0000543403140420151509013143342608' => {
              begin: '0000543403', day: '14', month: '04', year: '2015', hours: '15', minutes: '09', separator: '', pis: '013143342608', extra: ''
            },
            '0000543365140420151507I013143342608Eduardo Henrique Bogoni' => {
              begin: '0000543365', day: '14', month: '04', year: '2015', hours: '15', minutes: '07', separator: 'I', pis: '013143342608', extra: 'Eduardo Henrique Bogoni'
            },
            '0000543385140420151508A013143342608Eduardo Henrique Bogoni' => {
              begin: '0000543385', day: '14', month: '04', year: '2015', hours: '15', minutes: '08', separator: 'A', pis: '013143342608', extra: 'Eduardo Henrique Bogoni'
            },
            '0000543395140420151509A013143342608Eduardo Henrique Bogoni' => {
              begin: '0000543395', day: '14', month: '04', year: '2015', hours: '15', minutes: '09', separator: 'A', pis: '013143342608', extra: 'Eduardo Henrique Bogoni'
            },
            '0000113975020720141456A012780367034Claudio Renan da Costa Dias' => {
              begin: '0000113975', day: '02', month: '07', year: '2014', hours: '14', minutes: '56', separator: 'A', pis: '012780367034', extra: 'Claudio Renan da Costa Dias'
            },
            '0000113733020720141206020912762106' => {
              begin: '0000113733', day: '02', month: '07', year: '2014', hours: '12', minutes: '06', pis: '020912762106', extra: '', separator: ''
            },
            '0000001875300420141352A012346010083Amarildo Dias da Silva' => {
              begin: '0000001875', day: '30', month: '04', year: '2014', hours: '13', minutes: '52', separator: 'A', pis: '012346010083', extra: 'Amarildo Dias da Silva'
            },
            '0000001883300420141352012346010083' => {
              begin: '0000001883', day: '30', month: '04', year: '2014', hours: '13', minutes: '52', pis: '012346010083', extra: '', separator: ''
            }
          }
          samples.each do |k, v|
            assert_equal v, Sjap::Ponto::SuperFacil::PontoParser.parse_line(k)
          end
        end
      end
    end
  end
end
