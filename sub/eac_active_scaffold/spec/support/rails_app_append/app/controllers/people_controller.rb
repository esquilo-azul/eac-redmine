# frozen_string_literal: true

class PeopleController < ActionController::Base # rubocop:disable Rails/ApplicationController
  active_scaffold :person
end
