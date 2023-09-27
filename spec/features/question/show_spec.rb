# frozen_string_literal: true

require 'rails_helper'

feature 'User can see question and answer', "
  In order to get information from a community
  As an authorized user or a guest user
  I'd like to be able to see the question and it's answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, :answer) }

  scenario 'Authorized user can see question and answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content('body')
    expect(page).to have_content('MyText')
  end

  scenario 'Unauthorized user can see question and answer' do
    visit question_path(question)

    expect(page).to have_content('body')
    expect(page).to have_content('MyText')
  end
end
