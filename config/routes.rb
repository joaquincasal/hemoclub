Rails.application.routes.draw do
  resources :donantes
  # Defines the root path route ("/")
  get '/home', to: 'home#index'
end
