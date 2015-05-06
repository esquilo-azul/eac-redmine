# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap
  class EsostiLog
    def initialize usuario, senha
      @session = EadminHttpSession.new usuario, senha
    end

    def run
      loginFase = true
      runLoop = true
      while runLoop do
        begin
          if loginFase
            loginFase = login
          else
            loginFase = savePage
            log "Waiting..."
            sleep(15)
          end          
        rescue SignalException => e
          runLoop = false          
        rescue Exception => e  
          log "Rescued exception: " + e.message 
          puts e.backtrace.inspect
        end
      end
      log "Quit"
    end

    def login
      log "Logging..."
      loginResult = @session.login
      log "Login: " + loginResult.to_s
      return !loginResult
    end

    def savePage
      log "Downloading..."
      page = @session.caixaAtendimentoSecao
      if !@session.loggedUser?(page)
        log "User is not logged"
        return true
      end      
      file = '/home/eduardo/tmp/esosti/caixa-' + Time.now.strftime("%Y-%m-%d_%H-%M-%S") + '.html'
      File.write(file, page)
      log "Saved: " + file
      caixa =  CaixaAtendimentoSecao.new(page)
      solicitacoes = caixa.solicitacoesData
      log "Solicitações: " + solicitacoes.length.to_s
      for s in solicitacoes
        log "\t* " + s["numero"].to_s
        s.each do |key, value|
          if key != 'numero'
            log "\t\t* " + key + ": " + value
          end
       end    
      end
      if caixa.novaSolicitacao?
        log "Há alguma nova solicitação sem atendente"
        playAlarm
      end
      return false
    end
    
    def log(text)
      print Time.now.strftime("%m/%d/%Y %H:%M:%S") + ": " + text + "\n"
    end
    
    def playAlarm
      file = File.dirname(__FILE__) + "/fire-alarm.ogg"
      system 'paplay',file
    end

  end

end