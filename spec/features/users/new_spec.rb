# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'the new user page' do
  before { visit register_path }
  
  it 'displays a form to register as a user' do
    expect(page).to have_field :user_username
    expect(page).to have_field :user_email
    expect(page).to have_field :user_password
    expect(page).to have_field :user_password_confirmation
  end

  it 'when I fill out the form and submit' do
    fill_in :user_username, with: 'vivian1234'
    fill_in :user_email, with: 'viv34@email.com'
    fill_in :user_password, with: 'grumplethorpe10421'
    fill_in :user_password_confirmation, with: 'grumplethorpe10421'
    click_button 'Register'

    expect(page).to have_content "Welcome vivian1234!"
    expect(current_path).to eq(user_path(User.last))
  end

  it 'redirects to the register page if an email or username is not unique' do
    visit register_path

    fill_in :user_username, with: 'Vivian'
    fill_in :user_email, with: 'viv1234@gmail.com'
    fill_in :user_password, with: 'dsaflwefasdf'
    fill_in :user_password_confirmation, with: 'dsaflwefasdf'
    click_button 'Register'

    visit register_path

    fill_in :user_username, with: 'Vivian'
    fill_in :user_email, with: 'viv1234@gmail.com'
    fill_in :user_password, with: 'dsaflwefasdf'
    fill_in :user_password_confirmation, with: 'dsaflwefasdf'
    click_button 'Register'

    expect(current_path).to eq(register_path)
    expect(page).to have_content('Error: Username has already been taken, Email has already been taken')
  end

  it 'redirects to the register page if any field is not filled in' do
    visit register_path

    fill_in :user_username, with: 'Vivian'
    fill_in :user_email, with: 'vivain@asdfa.com'
    click_button 'Register'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Error: Password can't be blank")

    fill_in :user_username, with: 'Vivian'
    fill_in :user_password, with: 'dsaflwefasdf'
    fill_in :user_password_confirmation, with: 'dsaflwefasdf'
    click_button 'Register'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Error: Email can't be blank")

    fill_in :user_email, with: 'Vivia@agnas.com'
    fill_in :user_password, with: 'dsaflwefasdf'
    fill_in :user_password_confirmation, with: 'dsaflwefasdf'
    click_button 'Register'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Error: Username can't be blank")
  end

  it 'redirects back to register page if passwords do not match' do
    visit register_path

    fill_in :user_username, with: 'Vivian'
    fill_in :user_email, with: 'viv1234@gmail.com'
    fill_in :user_password, with: 'dsaflwefasdf'
    fill_in :user_password_confirmation, with: 'other_thing'
    click_button 'Register'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Error: Password confirmation doesn't match Password")
  end
end
