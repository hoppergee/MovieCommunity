Rails.application.routes.draw do
  devise_for :users
  resources :movies do
    
    member do
      post :follow
      post :unfollow
    end
    
    resources :reviews
  end
  root 'movies#index'
end
