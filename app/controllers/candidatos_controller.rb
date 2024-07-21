class CandidatosController < IntegracionesController
  def create
    body = JSON.parse(request.raw_post)
    info_candidato = body.slice("first_name", "last_name", "email", "mobile", "city")
                         .transform_keys({ "first_name" => "nombre", "last_name" => "apellidos",
                                           "email" => "correo_electronico", "mobile" => "telefono",
                                           "city" => "localidad" })
                         .merge({ "candidato" => true })

    if info_candidato.fetch("correo_electronico").present? && Donante.exists?(correo_electronico: correo_electronico)
      return head :ok
    end

    candidato = Donante.new(info_candidato)
    if candidato.save
      head :ok
    else
      head :internal_server_error
    end
  end
end
