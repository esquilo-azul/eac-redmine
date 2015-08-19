# encoding: UTF-8

require 'yaml'
require 'highline/import'

namespace :trf1_sjap do
  namespace :ponto do
    desc 'Replica as entradas de todos os terminais de ponto "Super Fácil"'
    task terminais_replicate: :environment do
      terminais = PontoTerminal.where(tipo: 'SUPERFACIL')
      Rails.logger.info "Terminais \"Super Fácil\" encontrados: #{terminais.count}"
      terminais.each do |terminal|
        Trf1Sjap::Ponto::SuperFacil::Replicate.new(terminal).run
      end
    end
  end
end
