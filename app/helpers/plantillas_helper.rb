module PlantillasHelper
  def atributos_donante
    Donante.columns.filter { |columna| columna.type == :string }.map { |columna| columna.name}
  end
end
