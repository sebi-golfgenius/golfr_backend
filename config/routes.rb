Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    post 'login', to: 'users#login'
    get 'feed', to: 'scores#user_feed'
    get 'show/:id', to: 'users#show'
    get 'scores/:id', to: 'scores#scores_for_user'
    resources :scores, only: %i[create destroy]
  end
end
