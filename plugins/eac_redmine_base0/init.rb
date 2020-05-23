# frozen_string_literal: true

require 'redmine'

require 'eac_redmine_base0/version'

Redmine::Plugin.register :eac_redmine_base0 do
  name 'EacRedmineBase0'
  author ::EacRedmineBase0::AUTHOR
  description ::EacRedmineBase0::SUMMARY
  version ::EacRedmineBase0::VERSION
end

Rails.configuration.to_prepare do
  require 'eac_redmine_base0/maintained_plugins'
end
