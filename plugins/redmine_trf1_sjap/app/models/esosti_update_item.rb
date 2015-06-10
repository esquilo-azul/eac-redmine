class EsostiUpdateItem < ActiveRecord::Base
  unloadable
  validates_presence_of :esosti_update_id, :nome
  validates_uniqueness_of :nome, scope: :esosti_update_id
  validates :valor, exclusion: { in: [nil] }
  belongs_to :esosti_update
end
