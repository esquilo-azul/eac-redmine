class PontoEntradasController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :ponto_entrada do |conf|
    conf.columns[:data_hora].form_ui = :datetime_picker
    conf.columns[:autor].form_ui = :select
    conf.columns[:funcionario].form_ui = :select
    conf.columns[:terminal].form_ui = :select
    conf.columns[:motivo].required = true
    conf.actions.swap :search, :field_search
    conf.field_search.columns = :funcionario, :data_hora
    conf.create.columns.exclude :autor, :terminal, :metodo
    conf.actions.exclude :update, :delete
    conf.action_links.add :cancela_input, type: :member, label: 'Cancelar'
  end

  def cancela_authorized?(record)
    authorize_cancela?(record)
  end

  def cancela_input_authorized?(record)
    authorize_cancela?(record)
  end

  def create_authorized?
    UserRole.user_has_role('ponto_entrada_create')
  end

  def list_authorized?
    UserRole.user_has_role('ponto_entrada_read')
  end

  def cancela_input
    @ponto = find_if_allowed(params[:id], :read)
    @record = PontoCancelamento.new
    @record.ponto_entrada = @ponto
    @column = active_scaffold_config.columns[:motivo]
    respond_to_action(:cancela_input)
  end

  def cancela
    process_action_link_action do |_record|
      @ponto = find_if_allowed(params[:id], :read)
      @record = PontoCancelamento.new
      @record.ponto_entrada = @ponto
      @record.autor = User.current
      @record.motivo = params[:record][:motivo]
      save_result = @record.save
      @record = @ponto if save_result
      self.successful = save_result
    end
  end

  def before_create_save(record)
    record.metodo = 'MANUAL'
    record.autor = User.current
  end

  private

  def authorize_cancela?(record)
    UserRole.user_has_role('ponto_cancelamento_create') && record.cancelamento.nil?
  end
end
