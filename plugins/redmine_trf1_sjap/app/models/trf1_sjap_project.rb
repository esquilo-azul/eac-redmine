# encoding: UTF-8
class Trf1SjapProject < ActiveRecord::Base
  attr_accessible :eadmin_matricula, :eadmin_senha, :eadmin_banco
  belongs_to :project
  validates_uniqueness_of :project_id
  validates_presence_of :project_id, :eadmin_matricula, :eadmin_senha, :eadmin_banco
  def to_s
    return project.to_s
  end

  def esosti_updates_abertos
    EsostiUpdate.
          where(journal_id: nil).
          includes(:esosti_solicitacao).
          where('esosti_solicitacaos.trf1_sjap_project_id' => id).
          order(:esosti_solicitacao_id, :index)
  end

end
