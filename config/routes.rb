Rails.application.routes.draw do
  authenticate :usuario, ->(usuario) { usuario.present? } do
    mount GoodJob::Engine => 'good_job'
  end

  scope(path_names: { new: 'nueva', edit: 'editar' }) do
    devise_for :usuarios, path_names: {
      sign_in: 'iniciar_sesion', sign_out: 'cerrar_sesion',
      password: 'contraseña', confirmation: 'confirmacion',
      invitation: 'invitaciones'
    }
    resources :usuarios, only: [:index, :destroy]
    resources :donantes do
      resources :exclusiones, only: [:new, :edit, :create, :update, :destroy]
      collection do
        get "importar", to: "donantes#import"
        post "importar", to: "donantes#do_import"
        get "errores", to: "donantes#import_errors"
        match 'buscar' => 'donantes#search', via: [:get, :post], as: :search
      end
    end
    resources :clinicas, param: :codigo, only: [:index, :new, :edit, :create, :update]
    resources :plantillas
    resources :listas do
      member do
        post "actualizar_donantes", to: "listas#actualizar_donantes"
      end
    end
    resources :difusiones do
      member do
        post "enviar", to: "difusiones#send_now"
        post "programar", to: "difusiones#schedule"
        delete "cancelar", to: "difusiones#cancel"
      end
    end
    resources :campanias
    get "graficos", to: "graficos#index"

    # Defines the root path route ("/")
    root "graficos#index"
    get "up" => "rails/health#show", as: :rails_health_check
  end
end
