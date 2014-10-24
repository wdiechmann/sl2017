Rails.application.routes.draw do
  resources :jobbers

  resources :entrances

  resources :employees do
    member do
      get 'last_seen'
    end
    resources :entrances
  end
  
  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
