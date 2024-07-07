module ListasHelper
  def filtros_disponibles
    [
      [FiltroPorAtributo.nombre, FiltroPorAtributo],
      [FiltroPorUltimaDonacion.nombre, FiltroPorUltimaDonacion],
      [FiltroPorInteraccion.nombre, FiltroPorInteraccion],
      [FiltroPorCumpleanios.nombre, FiltroPorCumpleanios]
    ]
  end

  def tipo_del(filtro)
    filtro["tipo"].constantize
  end

  def atributo_del(filtro)
    filtro["atributo"]
  end

  def valor_del(filtro)
    tipo_del(filtro).valores(atributo_del(filtro))
  end
end
