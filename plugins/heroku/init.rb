# coding: utf-8

require 'redmine'

Redmine::Plugin.register :heroku do
  name 'Heroku'
  author 'Eduardo Henrique Bogoni'
  description ''
  version '0.1.0'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :heroku_accounts, { controller: 'heroku_accounts', action: 'index' },
              caption: :label_heroku_accounts
  end
end
