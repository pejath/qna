# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Text question'
      fill_in 'Body', with: 'text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Text question'
      expect(page).to have_content 'text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'adds and removes multiple links to question' do
      click_on 'add link'
      expect(page).to have_selector('.nested-fields', count: 3)
      click_on 'remove link'
      expect(page).to have_selector('.nested-fields', count: 2)
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'question'
      fill_in 'Body', with: 'text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with reward' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Reward name', with: 'Test name'
      attach_file 'Image', "#{Rails.root}/app/assets/images/kit.png"
      click_on 'Ask'
    end
  end

  scenario 'Unauthenticated user tries to asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
