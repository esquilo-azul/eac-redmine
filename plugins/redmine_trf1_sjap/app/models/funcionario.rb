class Funcionario < ActiveRecord::Base
  validates :nome, presence: true
end
