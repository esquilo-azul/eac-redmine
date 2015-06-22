# encoding: UTF-8
class Trf1SjapProject < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :project_id
  validates_presence_of :project_id, :eadmin_matricula, :eadmin_senha, :eadmin_banco
  def to_s
    return project.to_s
  end

end
