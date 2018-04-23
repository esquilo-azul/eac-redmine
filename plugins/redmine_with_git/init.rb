# coding: utf-8

require 'redmine'

Redmine::Plugin.register :redmine_with_git do
  name 'RedmineWithGit'
  author 'Esquilo Azul Company'
  description 'Utilities for Redmine + plugin redmine_git_hosting.'
  version '0.1.0'
  url 'https://github.com/esquilo-azul/redmine_with_git'
  author_url 'https://github.com/esquilo-azul'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :redmine_with_git, { controller: 'redmine_with_git', action: 'index', id: nil },
              caption: 'Redmine with Git',
              if: proc { User.current.admin? }
  end

  requires_redmine_plugin :redmine_git_hosting, version_or_higher: '1.0.4'
end
