class FiltroPorCumpleanios
  def aplicar
    Donante.where('EXTRACT(month FROM fecha_nacimiento) = ? AND EXTRACT(day FROM fecha_nacimiento) = ?',
                  Time.zone.today.month, Time.zone.today.day)
  end

  def descripcion
    "El cumpleaños del donante es hoy."
  end

  def self.nombre
    "Cumpleaños del donante es hoy"
  end

  def self.atributo?
    false
  end

  def self.operador?
    false
  end
end
