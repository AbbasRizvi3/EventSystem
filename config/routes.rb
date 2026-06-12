Rails.application.routes.draw do
  get "notifications/index"
  get "home/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # get '/users', to: redirect('/events')

  root to: "home#index"
  get "/dashboard", to: "dashboard#index", as: :dashboard
  resources :events do
    collection do
    get :my_events
    end
    member do
      patch :cancel
    end
    resources :registrations, only: [ :create, :destroy, :index ]
    resources :waitlist_entries, only: [ :create, :destroy, :index ], controller: "wait_list_entries"
  end

  resources :users, only: [ :index, :show, :destroy, :new ] do
    collection do
      post :admin_create
    end
    member do
    patch :update_roles
  end
  end

  resources :notifications, only: [ :index ]




  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
