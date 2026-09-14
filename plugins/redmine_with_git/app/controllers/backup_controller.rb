# frozen_string_literal: true

class BackupController < ApplicationController
  PERMISSIONS = {}.freeze

  layout 'nonproject_modules'
  require_permission PERMISSIONS, only: [:index]

  helper ::RedmineWithGitHelper

  def index
    @load = ::RedmineWithGit::Tableless::Load.new
  end
end
