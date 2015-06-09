class EsostiUpdateItem < ActiveRecord::Base
  unloadable
  validates_presence_of :esosti_update_id, :nome, :valor
  validates_uniqueness_of :nome, scope: :esosti_update_id
  belongs_to :esosti_update
end
