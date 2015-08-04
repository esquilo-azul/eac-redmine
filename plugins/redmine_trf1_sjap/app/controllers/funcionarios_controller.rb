class FuncionariosController < ApplicationController
  layout 'trf1_sjap'
  active_scaffold :"funcionario" do |conf|
  end
end
