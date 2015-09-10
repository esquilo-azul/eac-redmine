# encoding: UTF-8
class Trf1SjapProject < ActiveRecord::Base
  attr_accessible :eadmin_matricula, :eadmin_senha, :eadmin_banco, :esosti_export_project_id
  belongs_to :project
  validates_uniqueness_of :project_id
  validates_presence_of :project_id, :eadmin_matricula, :eadmin_senha, :eadmin_banco
  delegate :to_s, to: :project

  def esosti_export_project
    if esosti_export_project_id
      Project.find(esosti_export_project_id)
    else
      project
    end
  end

  def create_eadmin_http_session
    Trf1Sjap::EadminHttpSession.new(
      eadmin_matricula,
      eadmin_senha,
      eadmin_banco
    )
  end
end
