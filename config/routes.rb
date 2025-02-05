Rails.application.routes.draw do
  devise_for :users

  # Rota raiz para usuários autenticados
  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end

  # Rota raiz para usuários não autenticados
  devise_scope :user do
    root to: "devise/sessions#new", as: :unauthenticated_root
  end

  # Rotas protegidas
  authenticate :user do
    resource :password_setup, only: [ :edit, :update ]
    resource :sigaa_update, only: [ :new, :create ]
    resources :form_templates
    resources :forms do
      member do
        get :results
        get :export_results
      end
      resources :responses, only: [ :new, :create ]
    end
    resources :pending_forms, only: [ :index ]
    get "dashboard", to: "dashboard#index"
  end

  # Rotas de redefinição de senha
  resource :password_reset, only: [ :new, :create, :edit, :update ]

  # Rota raiz padrão
  root "dashboard#index"

  # Rotas de health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
