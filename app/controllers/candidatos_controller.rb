class CandidatosController < IntegracionesController
  def create
    body = JSON.parse(request.raw_post)
    info_candidato = body.slice("first_name", "last_name", "email", "mobile", "city")
                         .transform_keys({ "first_name" => "nombre", "last_name" => "apellidos",
                                           "email" => "correo_electronico", "mobile" => "telefono",
                                           "city" => "localidad" })
                         .merge({ "candidato" => true })

    correo_electronico = info_candidato.fetch("correo_electronico", nil)
    return head :ok if correo_electronico.blank? || Donante.exists?(correo_electronico: correo_electronico)

    Donante.create(info_candidato)
    head :ok
  end
end
