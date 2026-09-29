# frozen_string_literal: true

class Person < ActiveRecord::Base
  validates :name, presence: true
  validates :age, presence: true, numericality: { greater_or_equal_to: 0 }
end
