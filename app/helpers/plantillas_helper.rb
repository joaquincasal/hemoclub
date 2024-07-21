module PlantillasHelper

  VARIABLES = %w[apellidos nombre segundo_nombre codigo_postal localidad grupo_sanguineo
                 factor cantidad_donaciones fecha_ultima_donacion link_recibir_recordatorios link_desuscribir]
  def atributos_donante
    VARIABLES
  end
end
