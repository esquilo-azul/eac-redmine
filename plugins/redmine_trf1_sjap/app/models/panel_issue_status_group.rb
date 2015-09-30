# encoding: UTF-8
class PanelIssueStatusGroup < ActiveRecord::Base
  attr_accessible :name, :empty_message, :permanent
  validates :name, presence: true
  validates :empty_message, presence: true
end
