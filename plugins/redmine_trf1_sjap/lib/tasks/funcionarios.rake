# encoding: UTF-8

require 'yaml'
require 'highline/import'
require 'csv'

namespace :trf1_sjap do
  namespace :funcionarios do
    task import_from_csv: :environment do
      csv_file = ARGV[1]
      unless File.exist?(csv_file)
        puts "Arquivo CSV \"{csv_file}\"não existe."
        break
      end
      puts "Fonte: \"#{csv_file}\""
      ActiveRecord::Base.transaction do
        CSV.foreach(csv_file, headers: true) do |row|
          data = row.to_hash
          data['cpf'] = data['cpf'].rjust(11, '0') if data.key?('cpf')
          puts data.inspect
          f = Funcionario.new(data)
          Trf1Sjap::ModelUtils.save_or_raise(f)
        end
      end
    end
  end
end
