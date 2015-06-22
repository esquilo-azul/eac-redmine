class EsostiFase < ActiveRecord::Base
  unloadable
  validates_presence_of :rotulo
  validates_uniqueness_of :rotulo
  belongs_to :issue_status
  
  def to_s
    rotulo
  end
end
