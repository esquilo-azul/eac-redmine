class PontoCargaHorariasController < ApplicationController
  include Sjap::RolesAuthorization
  include Index
  include Create
  include Cancelamento

  helper :funcionarios

  layout 'trf1_sjap'
  before_filter { |c| c.require_role('ponto_carga_horaria_read') }
end
