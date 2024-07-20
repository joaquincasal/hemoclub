Rails.application.routes.draw do
  authenticate :usuario, ->(usuario) { usuario.present? } do
    mount GoodJob::Engine => 'good_job'
  end

  post "interacciones", to: "interacciones#update"

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
        get "candidatos" => "donantes#index_candidatos"
        get "recordatorios" => "donantes#welcome"
      end
    end
    resources :clinicas, param: :codigo, only: [:index, :new, :edit, :create, :update]
    resources :plantillas
    resources :listas
    resources :campanias do
      member do
        post "enviar", to: "campanias#send_now"
        post "programar", to: "campanias#schedule"
        delete "cancelar", to: "campanias#cancel"
      end
    end
    resources :automatizaciones
    resources :exclusiones_tipicas
    get "informes", to: "informes#index"

    # Defines the root path route ("/")
    root "informes#index"
    get "up" => "rails/health#show", as: :rails_health_check
  end
end
