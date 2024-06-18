class FiltroPorInteraccion
  attr_reader :atributo, :operador, :valor

  def initialize(atributo:, operador:, valor: nil)
    @atributo = atributo
    @operador = operador
    if self.class.valores(@atributo)["tipo"] == "lista"
      @valor = self.class.valores(@atributo)["valores_query"][valor]
    else
      @valor = valor
    end
  end

  def aplicar
    validar_parametros
    Donante.joins(:interacciones, :ultima_donacion)
           .where(interacciones: { ejecutable_type: @atributo, ejecutable_id: @operador })
           .where("donaciones.fecha > interacciones.fecha")
  end

  def self.nombre
    "Donación posterior a contacto"
  end

  def self.atributos
    {
      "Campañas" => "Campania",
      "Difusiones" => "Difusion"
    }
  end

  def self.operadores(atributo)
    if atributo == "campanias"
      Campania.activa.each_with_object({}) do |campania, acumulador|
        acumulador[campania.nombre] = campania.id.to_s
      end
    else
      Difusion.all.each_with_object({}) do |difusion, acumulador|
        acumulador[difusion.nombre] = difusion.id.to_s
      end
    end
  end

  def self.valores(_atributo)
    {}
  end

  def self.nombre_dato(orden)
    {
      1 => "Campaña o Difusión",
      2 => "Comunicación enviada"
    }[orden].to_s
  end

  private

  def validar_parametros
    raise ArgumentError if self.class.atributos.values.exclude?(@atributo)
    raise ArgumentError if self.class.operadores(@atributo).values.exclude?(@operador)
  end
end
