# encoding: UTF-8
class Trf1SjapProject < ActiveRecord::Base
  attr_accessible :eadmin_matricula, :eadmin_senha, :eadmin_banco, :esosti_export_project_id
  belongs_to :project
  validates_uniqueness_of :project_id
  validates_presence_of :project_id, :eadmin_matricula, :eadmin_senha, :eadmin_banco
  def to_s
    return project.to_s
  end

  def esosti_export_project
    if esosti_export_project_id
      Project.find(esosti_export_project_id)
    else
      project
    end    
  end

  def esosti_updates_abertos
    EsostiUpdate.
          where(journal_id: nil).
          includes(:esosti_solicitacao).
          where('esosti_solicitacaos.trf1_sjap_project_id' => id).
          order(:esosti_solicitacao_id, :index)
  end
  
  def esosti_solicitacaos_sem_issue
    EsostiSolicitacao.
          where(issue_id: nil, trf1_sjap_project_id => id)
          order(id)
  end
  
  def create_eadmin_http_session
    Trf1Sjap::EadminHttpSession.new(
      eadmin_matricula,
      eadmin_senha,
      eadmin_banco
    )
  end

end
