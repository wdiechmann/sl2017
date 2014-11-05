Rails.application.routes.draw do
  resources :accounts

  resources :jobbers
  
  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
