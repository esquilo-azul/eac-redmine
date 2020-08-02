class HerokuAccountsController < ApplicationController
  layout 'admin_active_scaffold'
  before_action :require_admin

  active_scaffold :heroku_account do |_conf|
  end
end
