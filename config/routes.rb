Rails.application.routes.draw do
  devise_for :usuarios
  resources :donantes
  # Defines the root path route ("/")
  root "donantes#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
