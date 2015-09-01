class UserRole < ActiveRecord::Base
  ROLES = %w(
    papel1
    papel2
    papel3
  )
  belongs_to :user
  validates :user, presence: true
  validates :role, presence: true, inclusion: ROLES
  validates :role, uniqueness: { scope: [:user], message: 'Usuário já possui este perfil' }
end
