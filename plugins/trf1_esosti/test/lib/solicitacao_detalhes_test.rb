# encoding: UTF-8

require 'test_helper'

class Trf1Sjap::SolicitacaoDetalhesTest < ActiveSupport::TestCase
  def test_descricao
    file_test(:descricao,
              'solicitacao-detalhes_817986_2015-05-25_12-50-00.html',
              'Não consigo enviar mensagens com anexo'
             )
    file_test(:descricao,
              'solicitacao-detalhes_815452.html',
              'Problemas na impressão'
             )
  end

  def test_parse_updates_raw_data
    file_test(:parse_updates_raw_data, 'solicitacao-detalhes_817986_2015-05-25_12-50-00.html', [{
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 25/05/2015 12:45:05 0D 0h 0m 51s',
                'Por' => 'AP23PS - ADERVAN FRANS GUIMARAES MIRA JUNIOR',
                'Descrição' => '+ em atendimento'
              }, {
                'Fase' => 'CADASTRO SOLICITAÇÃO TI 25/05/2015 12:44:14 0D 0h 0m 0s',
                'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): SEÇÃO JUDICIÁRIA DO AMAPÁ - 5 - AP',
                'Serviço' => 'E-MAIL / CORREIO ELETRÔNICO',
                'Nível destino' => '2 - SERVIÇOS DE ATENDIMENTO TÉCNICO PRESENCIAL',
                'Por' => 'AP20105 - NERAÍNA LUÍZA CAETANO',
                'Descrição' => '+ Cadastro da Solicitação.'
              }, {
                'Descrição da Solicitação' => '+ Não consigo enviar mensagens com anexo'
              }
                                                                                               ])
    file_test(:parse_updates_raw_data, 'solicitacao-detalhes_815452.html', [{
                'Fase' => 'AVALIAÇÃO DE SERVIÇO DE TI 22/05/2015 11:13:18 2D 0h 11m 49s',
                'Avaliação' => 'ÓTIMO',
                'Por' => 'AP7903 - GRACIETE LOBATO VIDAL'
              }, {
                'Fase' => 'BAIXA SOLICITAÇÃO TI 20/05/2015 15:52:27 0D 4h 50m 57s',
                'Por' => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR',
                'Tombo' => '7436 - IMPRESSORA SAMSUNG ML-3750-ND.',
                'Descrição' => '+ serviço concluido.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 20/05/2015 11:01:58 0D 0h 0m 29s',
                'Por' => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR',
                'Tombo' => '7436 - IMPRESSORA SAMSUNG ML-3750-ND.',
                'Descrição' => '+ Em atendimento.'
              }, {
                'Fase' => 'CADASTRO SOLICITAÇÃO TI 20/05/2015 11:01:29 0D 0h 0m 0s',
                'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): SEÇÃO JUDICIÁRIA DO AMAPÁ - 5 - AP',
                'Serviço' => 'IMPRESSORA',
                'Nível destino' => '2 - SERVIÇOS DE ATENDIMENTO TÉCNICO PRESENCIAL',
                'Por' => 'AP7903 - GRACIETE LOBATO VIDAL',
                'Tombo' => '7436 - IMPRESSORA SAMSUNG ML-3750-ND.',
                'Descrição' => '+ Cadastro da Solicitação.'
              }, {
                'Descrição da Solicitação' => '+ Problemas na impressão'
              }])
    file_test(:parse_updates_raw_data, 'solicitacao-detalhes_749708.html', [{
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO ENTRE GRUPOS DO TRF1 07/05/2015 08:28:58 96D 14h 46m 48s',
                'Caixa destino' => 'CAIXA DE GESTÃO DE DEMANDAS DE TI DO(A): TRIBUNAL REGIONAL FEDERAL DA PRIMEIRA REGIÃO - 2 - TR',
                'Serviço' => 'E-CVD - CATALOGADOR VIRTUAL DE DOCUMENTOS',
                'Por' => 'TR18996PS - ANDRÉ DA SILVA VIDAL',
                'Descrição' => '+ Segue para análise.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 07/05/2015 07:00:30 96D 13h 18m 20s',
                'Por' => 'TR18846PS - PAULO RICARDO DA SILVA SANTANA',
                'Descrição' => '+ Segue para análise.'
              }, {
                'Fase' => 'DEVOLUÇÃO DE SOLICITAÇÃO DE TI 06/05/2015 20:56:34 96D 3h 14m 24s',
                'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): TRIBUNAL REGIONAL FEDERAL DA PRIMEIRA REGIÃO - 2 - TR',
                'Serviço' => 'JEF VIRTUAL - DOCUMENTOS',
                'Nível destino' => '1 - Serviço de Atendimento Técnico ao Cliente',
                'Por' => 'TR136903 - GLEYZIENE BARRETO',
                'Descrição' => '+ Não se trata de JEF Virtual. Att, Gleyziene'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO ENTRE GRUPOS DO TRF1 06/05/2015 17:54:52 96D 0h 12m 43s',
                'Caixa destino' => 'CAIXA DE GESTÃO DE DEMANDAS DE TI DO(A): TRIBUNAL REGIONAL FEDERAL DA PRIMEIRA REGIÃO - 2 - TR',
                'Serviço' => 'JEF VIRTUAL - DOCUMENTOS',
                'Por' => 'TR18997PS - LUCAS DE SOUZA GERÔNIMO',
                'Descrição' => '+ Favor, verificar pedido.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI DE SEÇÃO PARA O TRIBUNAL 06/05/2015 17:53:05 96D 0h 10m 55s',
                'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): TRIBUNAL REGIONAL FEDERAL DA PRIMEIRA REGIÃO - 2 - TR',
                'Serviço' => 'JEF VIRTUAL - DOCUMENTOS',
                'Nível destino' => '1 - Serviço de Atendimento Técnico ao Cliente',
                'Por' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS',
                'Descrição' => '+ O problema ainda persiste, favor verificar.'
              }, {
                'Fase' => 'AVALIAÇÃO DE SERVIÇO DE TI RECUSADA 06/05/2015 17:50:45 96D 0h 8m 36s',
                'Avaliação' => 'RECUSADA',
                'Por' => 'AP20060 - JOAQUIM DA SILVA OLIVEIRA',
                'Descrição' => '+ O problema ainda persiste. Consta outro e-sosti aberto desde 07/10/2014 para a resolução da inconsistência apresentada pelo referido sistema (nº da solicitação: 2014310000191001910160000016). Seguem telas atuais. Anexos: Tela e-cvd.icone indisponivel.pdf - tela complementos.pdf -'
              }, {
                'Fase' => 'BAIXA SOLICITAÇÃO TI 06/05/2015 16:47:38 95D 23h 5m 29s',
                'Por' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS',
                'Descrição' => '+ Serviço concluído. ' \
        'Solicitação está sendo baixada por se encontrar a mais de 04 (quatro) dias na caixa de entrada e sem retorno ao pedido de informação.'
              }, {
                'Fase' => 'SOLICITAÇÃO DE EXTENSÃO DE PRAZO PARA SOLICITAÇÃO DE TI 05/05/2015 17:57:43 95D 0h 15m 33s',
                'Prazo' => '06/05/2015 18:00:00',
                'Aprovação' => '',
                'Por' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS',
                'Descrição' => '+ Aguardando Servidor fazer o teste.'
              }, {
                'Fase' => 'PEDIDO DE INFORMAÇÃO PARA SOLICITAÇÃO À TI 29/04/2015 15:43:08 88D 22h 0m 59s',
                'Por' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS',
                'Descrição' => '+ Joaquim favor fazer o teste. Se o erro persistir, anexar a tela.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 29/04/2015 08:57:46 88D 15h 15m 36s',
                'Por' => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR',
                'Descrição' => '+ Favor verificar.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI DO TRIBUNAL PARA SEÇÃO 29/04/2015 08:55:07 88D 15h 12m 57s',
                'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): SEÇÃO JUDICIÁRIA DO AMAPÁ - 5 - AP',
                'Serviço' => 'JEF VIRTUAL - DOCUMENTOS',
                'Nível destino' => '2 - SERVIÇOS DE ATENDIMENTO TÉCNICO PRESENCIAL',
                'Por' => 'TR18996PS - ANDRÉ DA SILVA VIDAL',
                'Descrição' => '+ A tela em anexo demonstra que o usuário precisa configurar o plugin, favor orientar. ' \
        'Caso já tenha sido feita a configuração, então favor solicitar nova tela do erro, com log do console java.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 29/04/2015 06:59:54 88D 13h 17m 44s',
                'Por' => 'TR18846PS - PAULO RICARDO DA SILVA SANTANA',
                'Descrição' => '+ Segue para análise.'
              }, {
                'Fase' => 'DEVOLUÇÃO DE SOLICITAÇÃO DE TI 28/04/2015 20:38:56 88D 2h 56m 47s',
                'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): TRIBUNAL REGIONAL FEDERAL DA PRIMEIRA REGIÃO - 2 - TR',
                'Serviço' => 'E-CVD CATALOGADOR VIRTUAL DE DOCUMENTOS',
                'Nível destino' => '1 - Serviço de Atendimento Técnico ao Cliente',
                'Por' => 'TR114303 - MONICA REGINA FERREIRA RODRIGUES',
                'Descrição' => '+ À DIATU, para triagem. ' \
        'A tela em anexo demonstra que o usuário precisa configurar o plugin, favor orientar. ' \
        'Caso já tenha sido feita a configuração, então favor solicitar nova tela do erro, com log do console java. ' \
        'Att,'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO ENTRE GRUPOS DO TRF1 22/04/2015 15:39:17 81D 21h 57m 7s',
                'Caixa destino' => 'CAIXA DE GESTÃO DE DEMANDAS DE TI DO(A): TRIBUNAL REGIONAL FEDERAL DA PRIMEIRA REGIÃO - 2 - TR',
                'Serviço' => 'E-CVD - CATALOGADOR VIRTUAL DE DOCUMENTOS',
                'Por' => 'TR19021PS - FRANCISCO DE SÁ GUIMARÃES NETO',
                'Descrição' => '+ Prezados, Segue para verificação.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI DE SEÇÃO PARA O TRIBUNAL 22/04/2015 15:34:55 81D 21h 52m 45s',
                'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): TRIBUNAL REGIONAL FEDERAL DA PRIMEIRA REGIÃO - 2 - TR',
                'Serviço' => 'E-CVD CATALOGADOR VIRTUAL DE DOCUMENTOS',
                'Nível destino' => '1 - Serviço de Atendimento Técnico ao Cliente',
                'Por' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS',
                'Descrição' => '+ Favor verificar o seguinte erro citado pelo servidor no Catalogador de Sentenças.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI ENTRE GRUPOS DA MESMA SEÇÃO 02/02/2015 15:28:31 2D 20h 46m 21s',
                'Caixa destino' => 'CAIXA DE GESTÃO DE DEMANDAS DO ATENDIMENTO AOS USUÁRIOS DO(A): SEÇÃO JUDICIÁRIA DO AMAPÁ - 5 - AP',
                'Serviço' => 'CVS - CATALOGADOR VIRTUAL DE SENTENÇAS',
                'Por' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS',
                'Descrição' => '+ Favor verificar o seguinte erro citado pelo servidor no Catalogador de Sentenças, o Java platform está ativo já excluir o cache do Java mais o problema persiste.'
              }, {
                'Fase' => 'DAR PARECER NA SOLICITAÇÃO DE TI 02/02/2015 15:23:10 2D 20h 41m 0s',
                'Por' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS',
                'Descrição' => '+ Sim Ronaldo o console Java está ativado.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 02/02/2015 08:57:50 2D 14h 15m 41s',
                'Por' => 'AP29PS - RONALDO DIAS CARDOSO JUNIOR',
                'Descrição' => '+ Favor verificar se o complemento do Java console está ativado.'
              }, {
                'Fase' => 'ENCAMINHAMENTO DE SOLICITAÇÃO DE TI PARA CAIXA PESSOAL 30/01/2015 18:44:08 0D 0h 1m 58s',
                'Por' => 'AP58PS - ANAIDE CONCEICAO DOS SANTOS',
                'Descrição' => '+ Favor verificar'
              }, {
                'Fase' => 'CADASTRO SOLICITAÇÃO TI 30/01/2015 18:42:09 0D 0h 0m 0s',
                'Caixa destino' => 'CAIXA DE ATENDIMENTO AO USUÁRIO DO(A): SEÇÃO JUDICIÁRIA DO AMAPÁ - 5 - AP',
                'Serviço' => 'CVS - CATALOGADOR VIRTUAL DE SENTENÇAS',
                'Nível destino' => '2 - SERVIÇOS DE ATENDIMENTO TÉCNICO PRESENCIAL',
                'Por' => 'AP20060 - JOAQUIM DA SILVA OLIVEIRA',
                'Descrição' => '+ Cadastro da Solicitação. Anexos: Telas probelma e-CVD.pdf -'
              }, {
                'Descrição da Solicitação' => '+ Verificar erro no e-CVD SSJLJI, no que se refere ao link ' \
                  '(lupa) responsável pelo anexo dos documentos digitalizados. O acesso ao e-CVD encontra-se ' \
                  'normal. Entretanto, a catalogação de documentos não finaliza devido a falha no ' \
                  'link (lupa) responsável por localizar e anexar os documentos digitalizados.'
              }, {
                'Nome Documento' => 'Tela e-cvd.icone indisponivel.pdf',
                'Data de vinculação' => '06/05/2015 17:50:45'
              }, {
                'Nome Documento' => 'tela complementos.pdf',
                'Data de vinculação' => '06/05/2015 17:50:45'
              }, {
                'Nome Documento' => 'Telas probelma e-CVD.pdf',
                'Data de vinculação' => '30/01/2015 18:42:09'
              }])
  end

  def test_parse_properties_raw_data
    file_test(:parse_properties_raw_data, 'solicitacao-detalhes_749708.html', {
                'Solicitação Nº' => '2015310000196001960160000008',
                'Data da Solicitação' => '30/01/2015 18:42:09',
                'Unidade Solicitante' => 'SEPOD - SEÇÃO DE PROCESSAMENTO E PROCEDIMENTOS DIVERSOS - 196 - AP - /SEPOD/SECVA/VARA1/SSJLJI',
                'Nome do Solicitante' => 'JOAQUIM DA SILVA OLIVEIRA',
                'Matricula' => 'AP20060',
                'E-mail do Solicitante' => 'AP20060@trf1.jus.br',
                'Telefone' => '9636211534',
                'Local de Atendimento' => 'SECRETARIA',
                'Serviço Atual' => 'E-CVD - CATALOGADOR VIRTUAL DE DOCUMENTOS',
                'Descrição' => 'Verificar erro no e-CVD SSJLJI, no que se refere ao link (lupa) responsável pelo anexo dos documentos digitalizados. ' \
      'O acesso ao e-CVD encontra-se normal. Entretanto, a catalogação de documentos não finaliza devido a falha no link (lupa) responsável por localizar e anexar os documentos digitalizados.',
                'Observação' => 'Ao se clicar no referido link, a tela fica carregando e não finaliza. ' \
      'Encontra-se anexa a respectiva tela, bem como a tela de complementos do menu "ferramentas" onde há a possível causa do problema, conforme relatado por colegas da SJAP que passaram pela mesma situação.',
                'Encaminhado para' => '-'
              })
    file_test(:parse_properties_raw_data, 'solicitacao-detalhes_815452.html', {
                'Solicitação Nº' => '2015310000249002490160000025',
                'Data da Solicitação' => '20/05/2015 11:01:29',
                'Unidade Solicitante' => 'SEPCE - SECAO DE PROTOCOLO E CERTIDOES - 249 - AP - /SEPCE/NUCJU/SJAP',
                'Nome do Solicitante' => 'GRACIETE LOBATO VIDAL',
                'Matricula' => 'AP7903',
                'E-mail do Solicitante' => 'AP7903@trf1.jus.br',
                'Telefone' => '9691130865',
                'Local de Atendimento' => '- SEPCE',
                'Serviço Atual' => 'IMPRESSORA',
                'Tombo' => '7436 - IMPRESSORA SAMSUNG ML-3750-ND.',
                'Descrição' => 'Problemas na impressão',
                'Encaminhado para' => '-'
              })
    file_test(:parse_properties_raw_data, 'solicitacao-detalhes_830904.html', {
                'Solicitação Nº' => '2015310000269002690160000097',
                'Data da Solicitação' => '17/06/2015 11:18:27',
                'Unidade Solicitante' => 'SEINF - SEÇÃO DE TECNOLOGIA DA INFORMACAO - 269 - AP - /SEINF/NUCAD/SJAP',
                'Nome do Solicitante' => 'EDUARDO HENRIQUE BOGONI',
                'Matricula' => 'AP20199',
                'Por ordem de' => 'JU446 - LÍVIA CRISTINA MARQUES PERES',
                'E-mail do Solicitante' => 'eduardo.bogoni@trf1.jus.br',
                'Telefone' => '(96)3214-1526',
                'Local de Atendimento' => 'SEINF-AP',
                'Serviço Atual' => 'SESOF - Mensageria - Administrar Falhas em mensagens',
                'Descrição' => 'A Magistrada LÍVIA CRISTINA MARQUES PERES relata não estar recebendo mensagens de e-mail enviadas por dioleno.sousa@tre-ap.jus.br em sua caixa postal (livia.marques@trf1.jus.br). Foi verificado em seu Outlook (Caixa de entrada, Lixo Eletrônico, etc) e não encontramos a mensagem.' \
      ' Pedimos então que o responsável por dioleno.sousa@tre-ap.jus.br enviasse novamente a mensagem de email para eduardo.bogoni@trf1.jus.br e para um endereço do Gmail. A mensagem chegou somente no Gmail.' \
      ' Enviamos uma mensagem por um endereço do Gmail a livia.marques@trf1.jus.br. Essa mensagem chegou na sua caixa postal.',
                'Observação' => 'Suspeitamos que a mensagem de dioleno.sousa@tre-ap.jus.br esteja sendo bloqueada no servidor.',
                'Encaminhado para' => '-'
              })
  end

  private

  def file_test(method, file_name, expected_result)
    page = File.read(File.dirname(__FILE__) + '/' + file_name)
    detalhes = Trf1Sjap::SolicitacaoDetalhes.new(page)
    result = detalhes.send(method)
    assert_equal expected_result, result
  end
end
