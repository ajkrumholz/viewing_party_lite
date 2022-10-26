# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie results page' do

  describe 'When discover top rated movies is clicked', :vcr do
    it 'displays the 20 top rated movies' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:user_id_in_session).and_return(user.id)
      visit user_discover_index_path
      click_button 'Discover Top Rated Movies'
      movies = MoviesFacade.top_rated
      expect(current_path).to eq(user_movies_path(user))
      expect(page).to have_content(movies.first.title)
      expect(page).to have_content(movies.first.vote_average)
      expect(page).to have_content(movies.last.title)
      expect(page).to have_content(movies.last.vote_average)
      expect(page).to have_link(movies.first.title.to_s)
      click_link movies.first.title.to_s
      expect(page).to have_current_path user_movie_path(movies.first.id)
    end
  end

  describe 'When a movie title is searched', :vcr do
    it 'displays up to 40 results from the search' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:user_id_in_session).and_return(user.id)
      visit user_discover_index_path(user)
      fill_in 'Search', with: 'Top Gun'
      click_on 'Search by Movie Title'
      movies = MoviesFacade.search('Top Gun')
      expect(current_path).to eq(user_movies_path(user))
      expect(page).to have_content('Top Gun')
      expect(page).to have_link movies.first.title
      click_on movies.first.title
      expect(current_path).to eq(user_movie_path(movies.first.id))
    end

    it 'will return nothing if a movie title has no match' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:user_id_in_session).and_return(user.id)
      visit user_discover_index_path(user)
      fill_in 'Search', with: 'Top Gun 17'
      click_on 'Search by Movie Title'

      expect(current_path).to_not have_content('Top Gun')
    end
  end
end
