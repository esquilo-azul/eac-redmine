# frozen_string_literal: true

class BackupController < ApplicationController
  IMPORT_PERMISSION = 'redmine_with_git.backup.import'

  PERMISSIONS = { or: [IMPORT_PERMISSION] }.freeze

  layout 'nonproject_modules'
  require_permission PERMISSIONS, only: [:index]
  require_permission IMPORT_PERMISSION, only: [:import]

  accept_api_auth :import

  helper ::RedmineWithGitHelper

  def index
    @load = ::RedmineWithGit::Tableless::Load.new
  end

  def import
    @load = ::RedmineWithGit::Tableless::Load.new(import_params)
    @load.save
    respond_to do |format|
      format.html { import_respond_to_html }
      format.api { render_validation_errors(@load) }
    end
  end

  private

  def import_respond_to_html
    if @load.errors.empty?
      redirect_to backup_path, notice: 'Backup imported' # rubocop:disable Rails/I18nLocaleTexts
    else
      render :index
    end
  end

  def import_params
    ps = params[::RedmineWithGit::Tableless::Load.model_name.param_key]
    return {} if ps.blank?

    ps.permit(:path)
  end
end
