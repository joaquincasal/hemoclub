module PlantillasHelper

  VARIABLES = %w[apellidos nombre segundo_nombre codigo_postal localidad grupo_sanguineo
                 factor cantidad_donaciones fecha_ultima_donacion link_recibir_recordatorios link_desuscribir]

  IMAGENES = %w[donante.png gracias.png logo.png]
  def atributos_donante
    VARIABLES
  end

  def imagenes_disponibles
    IMAGENES
  end
end
