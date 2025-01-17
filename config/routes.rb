Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/register", to: "users#new"
  get "/login", to: "login#index"
  post "/login", to: "login#create"
  delete "/login", to: "login#destroy"
  resource :user, path: 'dashboard', only: %i[create show] do
    post "/movies_top_rated", to: "movies#top_rated"
    post "/movies_search", to: "movies#search"
    resources :discover, only: [:index], module: "users"
    resources :movies, only: %i[index show], module: "users" do
      resources :viewing_parties, only: %i[new create index show]
    end
  end
end
