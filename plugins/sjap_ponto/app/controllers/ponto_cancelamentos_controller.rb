class PontoCancelamentosController < ApplicationController
  layout 'trf1_sjap'
  active_scaffold :ponto_cancelamento do |conf|
    conf.actions.exclude :update, :delete, :create
  end

  def list_authorized?
    UserRole.user_has_role('ponto_cancelamento_read')
  end
end
