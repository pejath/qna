# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com' }

  scenario 'User adds link when adds answer' do
    sign_in(user)
    visit question_path(:question)

    fill_in 'answer[body]', with: 'Test question'

    fill_in 'Link name', with: 'Answer gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    expect(page).to have_link 'Answer gist', href: gist_url
  end
end
