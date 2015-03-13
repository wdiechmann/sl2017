Rails.application.routes.draw do
  resources :delivery_teams

  resources :assignments do
    member do
      get 'accepted_by_jobber'
      get 'accepted_by_dt'
      get 'declined_by_jobber'
      get 'declined_by_dt'
    end
  end

  resources :messages do
    collection do
      get 'format'
    end
  end

  resources :jobs do
    resources :jobbers
  end

  resources :accounts

  resources :jobbers do
    member do
      get 'confirmation'
      get "park"
    end
  end

  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
