Rails.application.routes.draw do
  resources :delivery_teams

  resources :assignments

  resources :messages do
    collection do
      get 'format'
    end
  end

  resources :jobs

  resources :accounts

  resources :jobbers do
    member do
      get 'confirmation'
    end
  end

  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
