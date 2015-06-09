class EsostiSolicitacao < ActiveRecord::Base
  unloadable
  validates_uniqueness_of :esosti_id 
  validates_uniqueness_of :issue_id, allow_nil: true
  validates_presence_of :esosti_id, :trf1_sjap_project_id
  validates :closed, exclusion: { in: [nil] }
  belongs_to :trf1_sjap_project  
end
