# encoding: UTF-8

require 'test_helper'
module Sjap
  module Ponto
    module SuperFacil
      class PontoParserTest < ActiveSupport::TestCase
        def test_parse_line
          samples = {
            '0000543403140420151509013143342608' => {
              nsr: '000054340', type: '3', day: '14', month: '04', year: '2015', hours: '15', minutes: '09', separator: '', pis: '013143342608', extra: ''
            },
            '0000543365140420151507I013143342608Eduardo Henrique Bogoni' => {
              nsr: '000054336', type: '5', day: '14', month: '04', year: '2015', hours: '15', minutes: '07', separator: 'I', pis: '013143342608', extra: 'Eduardo Henrique Bogoni'
            },
            '0000543385140420151508A013143342608Eduardo Henrique Bogoni' => {
              nsr: '000054338', type: '5', day: '14', month: '04', year: '2015', hours: '15', minutes: '08', separator: 'A', pis: '013143342608', extra: 'Eduardo Henrique Bogoni'
            },
            '0000543395140420151509A013143342608Eduardo Henrique Bogoni' => {
              nsr: '000054339', type: '5', day: '14', month: '04', year: '2015', hours: '15', minutes: '09', separator: 'A', pis: '013143342608', extra: 'Eduardo Henrique Bogoni'
            },
            '0000113975020720141456A012780367034Claudio Renan da Costa Dias' => {
              nsr: '000011397', type: '5', day: '02', month: '07', year: '2014', hours: '14', minutes: '56', separator: 'A', pis: '012780367034', extra: 'Claudio Renan da Costa Dias'
            },
            '0000113733020720141206020912762106' => {
              nsr: '000011373', type: '3', day: '02', month: '07', year: '2014', hours: '12', minutes: '06', pis: '020912762106', extra: '', separator: ''
            },
            '0000001875300420141352A012346010083Amarildo Dias da Silva' => {
              nsr: '000000187', type: '5', day: '30', month: '04', year: '2014', hours: '13', minutes: '52', separator: 'A', pis: '012346010083', extra: 'Amarildo Dias da Silva'
            },
            '0000001883300420141352012346010083' => {
              nsr: '000000188', type: '3', day: '30', month: '04', year: '2014', hours: '13', minutes: '52', pis: '012346010083', extra: '', separator: ''
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
