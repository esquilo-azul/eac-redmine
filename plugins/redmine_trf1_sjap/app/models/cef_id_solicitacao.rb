class CefIdSolicitacao < ActiveRecord::Base
  belongs_to :funcionario
  validates :funcionario, presence: true
end
