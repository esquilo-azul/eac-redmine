class EsostiUpdate < ActiveRecord::Base
  unloadable
  validates_uniqueness_of :index, scope: :esosti_solicitacao_id    
  validates_presence_of :esosti_solicitacao_id, :index  
  belongs_to :esosti_solicitacao

end
