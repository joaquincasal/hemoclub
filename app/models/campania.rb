class Campania < Comunicacion
  def programar_envio(fecha)
    ejecucion = Ejecucion.create!(comunicacion: self, fecha: fecha)
    EnviarComunicacionJob.set(wait_until: fecha).perform_later(ejecucion.id)
  end
end
