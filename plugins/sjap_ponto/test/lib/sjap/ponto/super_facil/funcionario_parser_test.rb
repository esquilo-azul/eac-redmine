# encoding: UTF-8

require 'test_helper'
module Sjap
  module Ponto
    module SuperFacil
      class FuncionarioParserTest < ActiveSupport::TestCase
        def test_parse_line
          samples = {
            '1+1+I[013143342608[Eduardo Henrique Bogoni[1[1[20199' => {
              pis: '013143342608', nome: 'Eduardo Henrique Bogoni', matricula: '20199'
            },
            '1+1+I[017055097280[Besaliel de Oliveira Rodrigues[1[1[20075' => {
              pis: '017055097280', nome: 'Besaliel de Oliveira Rodrigues', matricula: '20075'
            },
            '1+1+I[012036234994[Paulo de Oliveira Scarcela Portela[1[1[20049' => {
              pis: '012036234994', nome: 'Paulo de Oliveira Scarcela Portela', matricula: '20049'
            },
            '1+1+I[012649436036[Jefferson[1[1[20202' => {
              pis: '012649436036', nome: 'Jefferson', matricula: '20202'
            },
            '1+1+I[021279064120[TESTE HENRY[1[1[999' => {
              pis: '021279064120', nome: 'TESTE HENRY', matricula: '999'
            }
          }
          samples.each do |k, v|
            assert_equal v, Sjap::Ponto::SuperFacil::FuncionarioParser.parse_line(k)
          end
        end
      end
    end
  end
end
