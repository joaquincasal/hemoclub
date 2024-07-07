class FiltroPorCumpleanios
  attr_reader :atributo, :operador, :valor

  def aplicar
    Donante.where('EXTRACT(month FROM fecha_nacimiento) = ? AND EXTRACT(day FROM fecha_nacimiento) = ?',
                  Time.zone.today.month, Time.zone.today.day)
  end

  def self.nombre
    "Cumpleaños del donante"
  end

  private

  def validar_parametros
    raise ArgumentError if self.class.atributos.values.exclude?(@atributo)
    raise ArgumentError if self.class.operadores(@atributo).values.exclude?(@operador)
  end
end
