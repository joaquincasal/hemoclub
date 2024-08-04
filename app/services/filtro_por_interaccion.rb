class FiltroPorInteraccion
  MESES_DE_EFECTIVIDAD = 2

  def initialize(atributo:, _: nil, _: nil)
    @atributo = atributo
  end

  def descripcion
    "La última donación del donante fue luego de que se le envío la comunicación #{Comunicacion.find(@atributo).nombre}"
  end

  def aplicar
    validar_parametros!
    Donante.joins(:interacciones, :ultima_donacion)
           .where(interacciones: { comunicacion_id: @atributo })
           .where("donaciones.fecha > interacciones.fecha")
           .where("donaciones.fecha <= interacciones.fecha + interval '#{MESES_DE_EFECTIVIDAD} months'")
  end

  def self.nombre
    "Donación posterior a contacto"
  end

  def self.nombre_parametro(_)
    "Comunicación enviada"
  end

  def self.atributos
    Comunicacion.where(type: "Automatizacion", activa: true).or(Comunicacion.where(type: "Campania"))
                .each_with_object({}) do |comunicacion, acumulador|
      acumulador[comunicacion.nombre] = comunicacion.id.to_s
    end
  end

  def self.atributo?
    true
  end

  def self.operador?
    false
  end

  private

  def validar_parametros!
    raise ArgumentError if self.class.atributos.values.exclude?(@atributo.to_s)
  end
end
