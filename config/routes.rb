Rails.application.routes.draw do
  devise_for :usuarios
  resources :donantes
  # Defines the root path route ("/")
  root "donantes#index"
end
