Rails.application.routes.draw do
  # Enrollments routes.
  get "enrollments/create"
  get "enrollments/destroy"

  # Scanner routes.
  get 'scanner', to: 'scanner#index'
  get 'scanner/confirm', to: 'scanner#confirm'
  post 'scanner/register_attendance', to: 'scanner#register_attendance'

  # User Profile routes.
  resource :profile, only: [:show], controller: 'users'

  # Dashboard routes.
  get 'dashboard', to: 'dashboard#index'

  resources :courses do
    get 'scan_attendance', on: :member # /courses/:id/scan_attendance
    post 'register_attendance', on: :member # API endpoint

    resources :enrollments, only: [:create, :destroy]
  end

  resources :students do
    get 'badge', on: :member # /students/:id/badge path
  end

  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
   root "dashboard#index"
end
