class InteraccionesController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_usuario!

  def update
    json_params = JSON.parse(request.raw_post)
    Filtro.create!(condiciones: json_params)
  end
end
