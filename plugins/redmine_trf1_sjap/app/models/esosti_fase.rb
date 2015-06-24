class EsostiFase < ActiveRecord::Base
  unloadable
  attr_accessible :rotulo, :issue_status_id
  validates_presence_of :rotulo
  validates_uniqueness_of :rotulo
  belongs_to :issue_status
  
  def to_s
    rotulo
  end
end
