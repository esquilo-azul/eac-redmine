class FuncionariosController < ApplicationController
  layout 'active_scaffold'
  active_scaffold :"funcionario" do |conf|
  end
end
