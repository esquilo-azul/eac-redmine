# encoding: UTF-8

namespace :sjap do
  namespace :ponto do
    desc 'Replica as entradas de todos os terminais de ponto "Super Fácil"'
    task terminais_replicate: :environment do
      Sjap::Ponto::SuperFacil::Replicate.run_all
    end
  end
end
