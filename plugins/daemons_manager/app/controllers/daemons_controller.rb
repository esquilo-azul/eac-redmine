class DaemonsController < ApplicationController
  before_action :require_admin
  before_action :set_daemon, only: [:start]
  layout 'admin'

  def index
    @daemons = Daemon.all
  end

  def start
    @daemon = Daemon.find(params[:id])
    @daemon.start
    redirect_to daemons_url, notice: "Daemon inicializado"
  rescue ActiveRecord::RecordNotFound
    redirect_to daemons_url, notice: "Daemon não encontrado com o ID=#{params[:id]}" unless @daemon
  end
end
