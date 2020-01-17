# frozen_string_literal: true

require 'redmine'

Redmine::Plugin.register :deprecated do
  name 'Deprecated migrations'
  author 'Eduardo Henrique Bogoni'
  description 'Final destination for removed plugins\' content.'
  version '0.0.0'
end
