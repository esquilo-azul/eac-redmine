class UserRole < ActiveRecord::Base
  ROLES = %w(
    ponto_cancelamento_read
    ponto_cancelamento_create
    ponto_entrada_create
    ponto_entrada_read
  )
  belongs_to :user
  validates :user, presence: true
  validates :role, presence: true, inclusion: ROLES
  validates :role, uniqueness: { scope: [:user], message: 'Usuário já possui este perfil' }

  def self.user_has_role(role, user = false)
    fail "UserRole::ROLES não inclui o perfil \"#{role}\". Verifique." unless ROLES.include?(role)
    user = User.current unless user
    return false unless user
    !UserRole.where(user: user, role: role).empty?
  end
end
