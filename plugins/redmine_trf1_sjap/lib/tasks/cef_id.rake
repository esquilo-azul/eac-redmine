# encoding: UTF-8

require 'yaml'
require 'highline/import'
require 'csv'

namespace :trf1_sjap do
  namespace :cef_id do
    task :consulta_solicitacoes, [:cpf] => :environment do |_t, args|
      unless args.cpf
        puts 'CPF não informado.'
        next
      end
      puts "CPF: \"#{args.cpf}\""
      funcionario = Funcionario.find_by_cpf(args.cpf)
      unless funcionario
        puts 'Funcionário não encontrado.'
        next
      end
      puts "Funcionário: #{funcionario}"
      consulta = Trf1Sjap::CefId::ConsultaSolicitacoes.new(funcionario.cpf)
      puts "Solicitações encontradas: #{consulta.solicitacoes.count}"
      consulta.solicitacoes.each do |s|
        puts "\t#{s}"
        CefIdSolicitacao.import_from_hash(funcionario, s)
      end
    end
  end
end
