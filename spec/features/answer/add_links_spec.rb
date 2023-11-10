# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:google_url) { 'https://google.com' }

  scenario 'User adds link when adds answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'Test question'

    fill_in 'answer[links_attributes][0][name]', with: 'Google'
    fill_in 'answer[links_attributes][0][url]', with: google_url

    click_on 'Answer'

    expect(page).to have_link 'Google', href: google_url
  end
end
