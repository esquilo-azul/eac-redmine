module Sjap
  module RolesAuthorization
    def require_role(role)
      return unless require_login
      unless UserRole.user_has_role(role)
        render_403
        return false
      end
      true
    end
  end
end
