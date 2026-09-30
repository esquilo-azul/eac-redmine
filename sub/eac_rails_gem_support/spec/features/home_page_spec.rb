# frozen_string_literal: true

RSpec.describe 'Home page', :rails, type: :feature do
  it 'visit home' do
    visit '/'
    expect(page).to have_content 'Home'
  end
end
