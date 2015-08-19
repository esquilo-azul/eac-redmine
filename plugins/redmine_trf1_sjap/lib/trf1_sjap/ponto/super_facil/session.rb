# encoding: UTF-8

module Trf1Sjap
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

        def registros(data_hora_inicio, data_hora_termino)
          content = @http_client.get_content(
            server_url,
            'pgCode' => '8',
            'opType' => '5',
            'lblId' => '2',
            'visibleDiv' => 'communication',
            'lblNsrI' => '000000001',
            'lblNsrF' => '000066288',
            'lblDataI' => data_hora_inicio.strftime('%d/%m/%y+%H:%M'),
            'lblDataF' => data_hora_termino.strftime('%d/%m/%y+%H:%M')
          )
          content.force_encoding('iso-8859-1').encode('utf-8')
        end

        private

        def logged_user?(page_content)
          Nokogiri::HTML(page_content).at_xpath('//h1/text()').to_s == 'MENU'
        end

        def server_url
          "#{@root_url}/rep.html"
        end
      end
    end
  end
end
