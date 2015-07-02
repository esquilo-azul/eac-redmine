class EsostiSolicitacao < ActiveRecord::Base
  unloadable
  validates_uniqueness_of :esosti_id 
  validates_uniqueness_of :issue_id, allow_nil: true
  validates_presence_of :esosti_id, :esosti_numero, :trf1_sjap_project_id
  validates :closed, exclusion: { in: [nil] }
  belongs_to :trf1_sjap_project  
  belongs_to :issue
  
  def closed_by_update?
    for update in updates
      return true if update.fase.is_closed
    end
    return false
  end
  
  def updates 
    EsostiUpdate.where(:esosti_solicitacao_id => id).order('index asc')
  end
  
end
