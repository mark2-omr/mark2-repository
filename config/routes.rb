Rails.application.routes.draw do
  resources :surveys do
    member do
      get :download_file
      get :download_payload
    end
  end

  get "/api/:slug", to: "surveys#api"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  delete "/sign_out", to: "sessions#destroy"

  # Defines the root path route ("/")
  root "welcome#index"
end
