class PontoTerminalEntradasController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :ponto_terminal_entrada do |conf|
    conf.actions.exclude :create, :update, :delete
    conf.columns[:created_at].options[:format] = ''
  end
end
