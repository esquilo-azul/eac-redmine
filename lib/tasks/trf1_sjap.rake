# encoding: UTF-8

require 'highline'

namespace :trf1_sjap do
  desc "TODO"
  task :esosti_log => :environment do
    ui = HighLine.new
    usuario = ui.ask("Usuário do e-Admin: ") 
    senha = ui.ask("Senha do e-Admin: ") { |q| q.echo = false }
    Trf1Sjap::EsostiLog.new(usuario, senha).run
  end
end
