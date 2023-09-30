Rails.application.routes.draw do
  # Defines the root path route ("/")
  get '/home', to: 'home#index'
end
