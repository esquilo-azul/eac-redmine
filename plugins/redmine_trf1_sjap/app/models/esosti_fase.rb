class EsostiFase < ActiveRecord::Base
  unloadable
  validates_presence_of :rotulo
  validates_uniqueness_of :rotulo
  validates :issue_status, :presence => true
  belongs_to :issue_status
  
  def to_s
    rotulo
  end
end
