# frozen_string_literal: true

require 'redmine'
require 'redmine_with_git/version'

Redmine::Plugin.register :redmine_with_git do
  name 'RedmineWithGit'
  author 'Esquilo Azul Company'
  description 'Utilities for Redmine + plugin redmine_git_hosting.'
  version ::RedmineWithGit::VERSION
  url 'https://github.com/esquilo-azul/redmine_with_git'
  author_url 'https://github.com/esquilo-azul'
end
