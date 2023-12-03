Rails.application.routes.draw do
  resources :clinicas, param: :codigo, only: [:index, :new, :edit, :create, :update]
  devise_for :usuarios
  resources :donantes do
    collection do
      get "importar", to: "donantes#import"
      post "importar", to: "donantes#do_import"
    end
  end
  # Defines the root path route ("/")
  root "donantes#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
