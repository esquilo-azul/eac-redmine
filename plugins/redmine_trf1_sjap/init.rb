# coding: utf-8

require 'redmine'

Redmine::Plugin.register :redmine_trf1_sjap do
  name 'TRF1 - SJAP'
  author 'TRF1 - SJAP - SEINF'
  description 'Customizações para a SJAP'
  version '0.0.1'
  url 'http://172.18.4.200/redmine/projects/redmine'
  author_url 'http://172.18.4.200/redmine/projects/seinf-ap'  
  project_module :redmine_trf1_sjap do
    permission :manage_trf1_sjap, :trf1_sjap => :index
  end
  menu :project_menu, :redmine_trf1_sjap, { :controller => 'trf1_sjap', :action => 'index' }, :caption => :label_trf1_sjap, :after => :files, :param => :project_id
end
