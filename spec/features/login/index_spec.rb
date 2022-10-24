require 'rails_helper'

RSpec.describe 'Logging in' do
  it 'it can log in with valid credentials' do
    user = create :user
    visit root_path

    click_on "I already have an account"

    fill_in :username, with: user.username
    fill_in :password, with: user.password
    click_on "Log in"
    
    expect(current_path).to eq(user_path(user))
    expect(page).to have_content("Welcome back, #{user.username}!")
  end

  it 'displays an error with invalid password' do
    user = create :user
    visit root_path

    click_on "I already have an account"

    fill_in :username, with: user.username
    fill_in :password, with: "wrong password"
    click_on "Log in"
    
    expect(current_path).to eq(login_path)
    expect(page).to have_content("Incorrect password, please try again")
  end
end