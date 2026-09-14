# frozen_string_literal: true

class BackupController < ApplicationController
  PERMISSIONS = {}.freeze

  layout 'nonproject_modules'
  require_permission PERMISSIONS, only: []

  helper ::RedmineWithGitHelper
end
