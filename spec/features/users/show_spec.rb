# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user dashboard' do
  describe 'when I visit a user dashboard', :vcr do
    let!(:user) { create :user }
    let!(:friend) { create :user }

    before :each do
      @movies = MoviesFacade.top_rated
      @movie_1 = @movies[0]
      @movie_2 = @movies[1]
      @viewing_party_1 = ViewingParty.create!(duration: 300,
                                              start_time: Faker::Time.forward(days: 7, period: :evening), movie_id: @movie_1.id, movie_title: @movie_1.title, host_id: user.id)
      @viewing_party_2 = ViewingParty.create!(duration: 300,
                                              start_time: Faker::Time.forward(days: 7, period: :evening), movie_id: @movie_2.id, movie_title: @movie_2.title, host_id: friend.id)
      @vpu_1 = ViewingPartyUser.create!(user_id: user.id, viewing_party_id: @viewing_party_1.id, hosting: true)
      @vpu_4 = ViewingPartyUser.create!(user_id: friend.id, viewing_party_id: @viewing_party_1.id, hosting: false)
      @vpu_2 = ViewingPartyUser.create!(user_id: user.id, viewing_party_id: @viewing_party_2.id, hosting: false)
      @vpu_3 = ViewingPartyUser.create!(user_id: friend.id, viewing_party_id: @viewing_party_2.id, hosting: true)
      allow_any_instance_of(ApplicationController).to receive(:user_id_in_session).and_return(user.id)
      visit user_path(user)
    end

    it 'displays a user name' do
      expect(page).to have_content("#{user.username}'s Dashboard")
    end

    it 'displays a discover movies button that links to a discover page for this specific user' do
      expect(page).to have_button('Discover Movies')

      click_button 'Discover Movies'

      expect(current_path).to eq(user_discover_index_path(user))
    end

    it 'lists viewing parties the user is invited to as a link to the movie show page', :vcr do
      within '#invited-parties' do
        expect(page).to have_link @viewing_party_2.movie_title.to_s

        click_link @viewing_party_2.movie_title
        expect(current_path).to eq(user_movie_path(user, @movie_2.id))
      end
    end

    it 'lists parties the user is invited to that include movie image/date and time/who is hosting/users invited with my own name in bold',
       :vcr do
      within '#invited-parties' do
        sentence_element = find('p.user-name')
        expect(page).to have_xpath("//img[contains(@src, 'https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg')]")
        expect(page).to have_content(@viewing_party_2.start_time.strftime('The party starts at %I:%M %p on %B %d, %Y'))
        expect(page).to have_content("Host: #{friend.username}")
        expect(page).to have_content(user.username)
        expect(sentence_element).to have_css('b', text: user.username.to_s)
      end
    end

    it 'lists viewing parties the user is hosting as a link to the movie show page', :vcr do
      within '#hosted-parties' do
        expect(page).to have_link @viewing_party_1.movie_title.to_s
        click_link @viewing_party_1.movie_title
        expect(current_path).to eq(user_movie_path(user, @movie_1.id))
      end
    end

    it 'lists parties the user is hosting that include movie image/date and time/specifies user is hosting/friends invited',
       :vcr do
      within '#hosted-parties' do
        expect(page).to have_xpath("//img[contains(@src, 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg')]")
        expect(page).to have_content(@viewing_party_1.start_time.strftime('The party starts at %I:%M %p on %B %d, %Y'))
        expect(page).to have_content(friend.username)
        expect(page).to have_content("Host: #{user.username}")
      end
    end
  end
end
