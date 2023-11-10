# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search for answers, questions, comments and users', "
  In order to find needed answer, question, comment or/and user
  As a User
  I'd like to be able to search for the information
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, body: 'something') }
  given!(:comment) { create(:comment, commentable: question) }

  background { visit root_path }

  describe 'User searches for the single type:', sphinx: true, js: true do
    scenario 'Answer' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'something'
        check 'filters_filter_answer'
        click_on 'Search'

        within '.search_results' do
          expect(page).to have_content 'something'
        end
      end
    end

    scenario 'Question' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'body'
        check 'filters_filter_question'
        click_on 'Search'

        within '.search_results' do
          expect(page).to have_content 'body'
        end
      end
    end

    scenario 'Comment' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'body'
        check 'filters_filter_comment'
        click_on 'Search'

        within '.search_results' do
          expect(page).to have_content 'comment body'
        end
      end
    end

    scenario 'User' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test'
        check 'filters_filter_user'
        click_on 'Search'

        within '.search_results' do
          expect(page).to have_content user.email
        end
      end
    end
  end
end
