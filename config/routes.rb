Rails.application.routes.draw do


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  controller :sessions do
    get 'auth/auth0/callback' => :callback
    get 'auth/failure' => :failure
    get 'logout' => :destroy
  end

  namespace :api do
    resources :exercises, only: :index
    resources :users, only: :index
    resources :guides, only: [:index, :create]
  end

  root to: 'chapters#index'

  resources :chapters, only: [:index, :show]

  # All users
  resources :exercises, only: [:show, :index] do
    # Current user
    resources :solutions, controller: 'exercise_solutions', only: :create
    resources :queries, controller: 'exercise_query', only: :create
  end

  resource :pdfs

  # All users
  resources :guides, only: [:show, :index]

  # All users
  resources :users, only: [:show, :index] do
    #nested user
    resources :assignments, controller: 'user_assignments', only: :index
  end
end
