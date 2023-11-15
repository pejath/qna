# frozen_string_literal: true

require 'rails_helper'

feature 'Author of question can choose the best answer', "
  In order to show the most helpful answer
  As an author of the question
  I'd like to be able to choose the best answer
" do
  given!(:user) { create(:user) }
  given!(:user_2) { create(:user) }
  given!(:question) { create(:question, :with_reward, user:) }
  given!(:answer) { create(:answer, question:, user: user_2, body: 'Best answer') }

  describe 'Author of question', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can choose the best answer' do
      click_on 'Best'

      expect(page).to have_content 'Best answer:'
    end

    scenario 'can choose other answer as the best' do
      create(:answer, question:, user: user_2, best: true, body: 'The best answer')

      click_on 'Best'

      expect(page).to have_content "Best answer: #{answer.body}"
    end
  end

  scenario 'Other user can not choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end

  scenario 'Unautheticated user can not choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end
end
