class UserRolesController < ApplicationController
  layout 'trf1_sjap'
  before_filter :require_admin
  active_scaffold :user_role do |conf|
    conf.columns[:user].form_ui = :select
    conf.columns[:role].form_ui = :select
    conf.columns[:role].options = { options: UserRole::ROLES.map { |n| [n, n] } }
  end
end
