# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class Session
        def initialize(root_url, username, password)
          @root_url = root_url
          @username = username
          @password = password
          @http_client = HTTPClient.new
        end

        def login
          content = @http_client.get_content(
            server_url,
            'pgCode' => '7',
            'opType' => '1',
            'lblId' => '0',
            'lblLogin' => @username,
            'lblPass' => @password
          )
          logged_user?(content)
        end

        def pontos
          export(8, 5)
        end

        def funcionarios
          export(10, 5)
        end

        private

        def logged_user?(page_content)
          Nokogiri::HTML(page_content).at_xpath('//h1/text()').to_s == 'MENU'
        end

        def export(pgCode, opType)
          content = @http_client.get_content(
            server_url,
            'pgCode' => pgCode.to_s,
            'opType' => opType.to_s
          )
          content.force_encoding('iso-8859-1').encode('utf-8')
        end

        def server_url
          "#{@root_url}/rep.html"
        end
      end
    end
  end
end
