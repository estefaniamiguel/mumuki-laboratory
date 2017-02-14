Rails.application.routes.draw do

  Mumukit::Login.configure_login_routes! self

  root to: 'home#index'

  # All users
  resource :user, only: :show

  # Current user
  resources :comments, only: :index

  scope '/:organization' do
    resources :book, as: 'organization_book', only: [:show]
    resources :chapters, as: 'organization_chapters', only: [:show] do
      resource :appendix, only: :show
    end

    # All users
    resources :exercises, as: 'organization_exercises', only: [:show, :index] do
      # Current user
      resources :solutions, controller: 'exercise_solutions', only: :create
      resources :queries, controller: 'exercise_query', only: :create
    end

    # All users
    resources :guides, as: 'organization_guides', only: [:show, :index]
    resources :lessons, as: 'organization_lesson', only: [:show]
    resources :complements, as: 'organization_complements', only: [:show]
    resources :exams, as: 'organization_exams', only: [:show]

    # Routes by slug
    get '/guides/:first/:second' => 'guides#show_by_slug', as: :organization_guide_by_slug
    get '/exercises/:first/:second/:bibliotheca_id' => 'exercises#show_by_slug', as: :organization_exercise_by_slug
  end

  #Rescue not found routes
  get '*not_found', to: 'application#not_found'
end
