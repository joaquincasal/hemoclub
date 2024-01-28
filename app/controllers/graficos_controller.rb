class GraficosController < ApplicationController
  def index
    @donantes_por_tipo = donantes_por_tipo
    @donaciones_aptas = donaciones_aptas
    @donaciones_por_mes = donaciones_por_mes
    @predonantes_aptos = predonantes_aptos
    @grupo_y_factor = grupo_y_factor
    @donaciones_por_institucion = donaciones_por_institucion
  end

  private

  def donaciones_por_institucion
    Donacion.joins(:clinica).select('clinicas.nombre').group('clinicas.nombre').count
  end

  def grupo_y_factor
    Donante.where.not(factor: nil).where.not(grupo_sanguineo: nil).group(:factor, :grupo_sanguineo).count
  end

  def donaciones_por_mes
    Donacion.where(fecha: 1.year.ago.next_month..).group_by_month(:fecha, format: "%B").count
  end

  def donantes_por_tipo
    Donante.group(:tipo_donante).count
  end

  def donaciones_aptas
    donaciones = Donacion.no_rechazadas.group(:serologia).count
    donaciones['Aptas'] = donaciones.delete 'negativa'
    donaciones['Rechazadas'] = Donacion.rechazadas.count
    donaciones['Serología reactiva'] = donaciones.delete 'reactiva'
    donaciones['Sin información'] = donaciones.delete nil
    donaciones
  end

  def predonantes_aptos
    predonantes = {}
    predonantes['Aptos'] = Donante.predonantes_aptos.count
    predonantes['Rechazados'] = Donante.predonantes_rechazados.count
    predonantes
  end
end
