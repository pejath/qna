# frozen_string_literal: true

require 'rails_helper'

feature 'Author can destroy answer', "
  In order to get cleaness
  As an authorized user
  I'd like to be able to destroy the answer
" do
  given!(:author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user_id: author.id) }

  scenario 'author tries to destroy the answer', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'another user cannot delete someones answer', js: true do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
