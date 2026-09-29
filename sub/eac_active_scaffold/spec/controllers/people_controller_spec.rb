# frozen_string_literal: true

RSpec.describe PeopleController, type: :feature do
  include_context 'active_scaffold_controller',
                  index_path: '/people',
                  valid_data: { name: 'Fulano de Tal', age: 55 }
end
