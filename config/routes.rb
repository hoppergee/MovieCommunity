Rails.application.routes.draw do
  devise_for :users
  resources :movies do
    
    member do
      post :follow
      post :unfollow
    end
    
    resources :reviews
  end
  
  namespace :account do
    resources :movies
  end
  
  root 'movies#index'
end
