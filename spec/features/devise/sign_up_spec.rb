# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
  As an unauthorized user
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'test@mail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    within('.actions') do
      click_on 'Sign up'
    end
    expect(page).to have_content 'Log Out'
  end

  scenario 'Unregistered user tries to sign up with errors' do
    fill_in 'Email', with: 'test@mail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match"
  end
end
