# frozen_string_literal: true

require 'rails_helper'

feature 'Author of the question or the answer can delete attached files', "
  In order to get the question or the answer cleaner
  As an author of the question or the answer
  I'd like to be able to delete attached files
" do
  given!(:author) { create :user }
  given!(:question) { create :question, :with_file, user: author }
  given!(:answer) { create :answer, :with_file, user: author, question: question }

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'tries to delete the question file', js: true do
      within '.question' do
        click_on 'delete file'
        expect(page).not_to have_link('rails_helper.rb')
      end
    end

    scenario 'tries to delete the answer file', js: true do
      within '.answers' do
        click_on 'delete file'
        expect(page).not_to have_link('rails_helper.rb')
      end
    end
  end
end
