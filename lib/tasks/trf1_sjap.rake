# encoding: UTF-8

require 'trf1_sjap/eadmin_http_session'
require 'yaml'
require 'highline/import'

namespace :trf1_sjap do

  task :eadmin_login => :environment do
    eadmin_http_session()
  end

  def eadmin_http_session
    config_path = ENV['HOME'] + '/.config/trf1-redmine/eadmin-login.yml'
    config = {:nome => 'Eduardo', :cidade=>'Macapá'}
    begin
      config = YAML.load_file(config_path)
      say("Login do e-Admin retirado de \"#{config_path}\"")
    rescue Errno::ENOENT => ex
      say("Arquivo de configuração \"<%= color('#{config_path}', BOLD) %>\" ainda não existe")
      config = {}
      config[:login] = ask("E-admin login? ")
      config[:senha]= ask("E-admin senha: ") { |q| q.echo = "*" }
      config[:banco] = ask("E-admin banco: ")
    end

    session = Trf1Sjap::EadminHttpSession.new(config[:login], config[:senha], config[:banco])
    say('Efetuando login...')
    loginResult = session.login
    if loginResult === true
      if ! File.exist?(config_path)
        say('Login ok. Salvando arquivo de configuração...')
        FileUtils::mkdir_p(File.dirname(config_path))
        File.write(config_path, config.to_yaml)        
        say('Arquivo salvo')
      end
    return session
    else
      say("<%= color('Login falhou: #{loginResult}', RED) %>")
      return nil
    end

  end

end

