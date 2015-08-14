class DaemonsController < ApplicationController
  before_action :require_admin
  layout 'admin'

  def index
    @daemons = find_all
  end

  private

  def find_all
    Daemons::Rails::Monitoring.statuses.map { |v| Daemons::Rails::Monitoring.controller(v[0]) }
  end
end
