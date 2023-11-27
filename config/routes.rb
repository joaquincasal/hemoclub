Rails.application.routes.draw do
  resources :clinicas, param: :codigo, only: [:index, :new, :edit, :create, :update]
  devise_for :usuarios
  resources :donantes
  # Defines the root path route ("/")
  root "donantes#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
