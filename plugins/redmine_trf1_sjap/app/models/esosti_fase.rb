class EsostiFase < ActiveRecord::Base
  unloadable
  attr_accessible :rotulo, :issue_status_id, :is_closed
  validates_presence_of :rotulo
  validates_uniqueness_of :rotulo
  belongs_to :issue_status

  def to_s
    rotulo
  end

  def is_closed_by_rotulo(fase_rotulo)
    fase = EsostiFase.find_by_rotulo(fase_rotulo)
    fase && fase.is_closed
  end
end
