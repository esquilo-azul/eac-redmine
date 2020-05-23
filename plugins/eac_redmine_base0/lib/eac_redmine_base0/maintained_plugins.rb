# frozen_string_literal: true

require 'redmine/plugin'

module EacRedmineBase0
  MAINTAINED_PLUGINS_NAMES = %w[
    eac_redmine_base0 eac_redmine_usability notifyme redmine_avm redmine_events_manager
    redmine_nonproject_modules redmine_plugins_helper redmine_remotes redmine_tasks_scheduler
    redmine_with_git
  ].freeze

  class << self
    def maintained_plugins
      @maintained_plugins ||= ::Redmine::Plugin.registered_plugins.values.select do |plugin|
        MAINTAINED_PLUGINS_NAMES.include?(plugin.id.to_s)
      end
    end
  end
end
