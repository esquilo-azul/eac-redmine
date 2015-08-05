class FuncionariosController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :"funcionario" do |conf|
  end
end
