# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to help someone
  As an authenticated user
  I'd like to be able to answer the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'answer[body]', with: 'MyAnswer'
      click_on 'Answer'

      expect(page).to have_content 'Title'
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'MyAnswer'
      end
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content("Body can't be blank")
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content("Body can't be blank")
    end

    scenario 'creates answer with attached file', js: true do
      fill_in 'answer[body]', with: 'My answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthorized user tries to answer the question' do
    visit question_path(question)
    fill_in 'answer[body]', with: 'My Answer'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
