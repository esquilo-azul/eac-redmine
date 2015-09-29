class CefIdSolicitacaosController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :cef_id_solicitacao do |conf|
    conf.columns[:funcionario].form_ui = :select
    conf.list.columns.exclude :created_at
    conf.list.columns.exclude :updated_at
  end
end
