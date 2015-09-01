# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class FuncionarioParser
        def self.parse_line(line)
          match = /^1\+1\+I\[(.+)\[(.+)\[\d\[\d\[(.+)$/.match(line)
          fail "\"#{line} não está no formato necessário" unless match
          { pis: match[1], nome: match[2], matricula: match[3] }
        end
      end
    end
  end
end
