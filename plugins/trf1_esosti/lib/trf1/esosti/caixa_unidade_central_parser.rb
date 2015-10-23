module Trf1
  module Esosti
    class CaixaUnidadeCentralParser
      def initialize(content)
        @doc = Nokogiri::HTML(content) { |c| c.noblanks }
      end

      def unidades_filter_options
        r = {}
        @doc.xpath("id('MODE_ID_CAIXA_ENTRADA')/option").each do |o|
          r[o.at_xpath('@value').text.strip] = o.text.strip
        end
        r
      end
    end
  end
end
