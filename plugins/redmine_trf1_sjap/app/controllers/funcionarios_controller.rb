class FuncionariosController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :"funcionario" do |conf|
    conf.list.columns.exclude :created_at
    conf.list.columns.exclude :updated_at
  end
end
