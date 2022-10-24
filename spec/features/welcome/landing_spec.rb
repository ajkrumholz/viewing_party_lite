# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'landing page' do
  describe 'when I visit the landing page' do

    before(:each) do
      visit '/'
    end

    it 'displays the title of the application' do
      expect(page).to have_content 'Viewing Party'
    end

    it 'has a link to create a new user' do
      expect(page).to have_link 'Register as a User'
    end

    it 'when I click the register user link' do
      click_on 'Register as a User'

      expect(current_path).to eq(register_path)
    end

    it 'has a link for existing user login' do
      expect(page).to have_link "I already have an account"

      click_link "I already have an account"

      expect(current_path).to eq(login_path)
    end

    it 'links back to landing page' do
      expect(page).to have_link('Home')

      click_on 'Home'

      expect(page).to have_current_path(root_path)
    end
  end
end
