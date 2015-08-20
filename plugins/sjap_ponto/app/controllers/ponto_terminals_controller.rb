class PontoTerminalsController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :ponto_terminal do |conf|
    conf.columns[:tipo].options = { options: PontoTerminal::TIPOS.map { |n| [n, n] } }
    conf.columns[:tipo].form_ui = :select
  end
end
