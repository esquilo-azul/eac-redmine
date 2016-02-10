# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Import
        module Base
          def sanitize_pis(pis)
            pis.gsub(/^0+/, '')
          end
        end
      end
    end
  end
end
