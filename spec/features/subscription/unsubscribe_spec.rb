# frozen_string_literal: true

require 'rails_helper'

feature 'User can unsubscribe from question', "
  In order to stop getting notice with answer
  As an authenticated user
  I'd like to be able to stop receiving notices
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:sub) { create(:subscription, user: user, question: question) }

  describe 'Authenticated user', js: true do
    scenario 'user unsubscribes' do
      sign_in(user)

      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not unsubscribe' do
      visit question_path(question)

      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
