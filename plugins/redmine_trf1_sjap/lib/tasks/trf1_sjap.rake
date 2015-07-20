# encoding: UTF-8

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
  
  task :nokogiri_parse, :input_file, :xpath  do |t, args|
    doc = Nokogiri::HTML(File.read(args.input_file))
    if args.xpath == nil
      nodes = [doc.root]
    else
      puts "XPATH: " + args.xpath
      nodes = doc.xpath(args.xpath)
      
    end
    puts "NODES FOUND: " + nodes.length.to_s
    for node in nodes
      puts '==========================================='
      print_node(node, 0)
    end
  end
  
  def print_node(node,level)
    if node.kind_of?(Nokogiri::XML::Element) 
      puts "  " * level + node.name
      for child in node.children
        print_node(child, level + 1)
      end
    end
  end

end

