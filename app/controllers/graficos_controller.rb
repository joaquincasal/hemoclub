class GraficosController < ApplicationController
  def index
    @donantes_por_tipo = donantes_por_tipo
    @donaciones_por_mes = donaciones_por_mes
    @predonantes_aptos = predonantes_aptos
    @grupo_y_factor = grupo_y_factor
    @donaciones_por_institucion = donaciones_por_institucion
    @predonantes_recientes = predonantes_recientes
  end

  private

  def donaciones_por_institucion
    Donacion.joins(:clinica).select('clinicas.nombre').group('clinicas.nombre').count
  end

  def grupo_y_factor
    Donante.where.not(factor: nil).where.not(grupo_sanguineo: nil).group(:factor, :grupo_sanguineo).count
  end

  def donaciones_por_mes
    donaciones = Donacion.no_rechazadas
                         .group(:serologia)
                         .where(fecha: 1.year.ago.next_month..)
                         .group_by_month(:fecha, format: "%B")
                         .count
    rechazadas = Donacion.rechazadas
                         .where(fecha: 1.year.ago.next_month..)
                         .group_by_month(:fecha, format: "%B")
                         .count
    rechazadas.each do |mes, valor|
      donaciones[['rechazada', mes]] = valor
    end
    donaciones.transform_keys! do |tipo, mes|
      next ['Apta', mes] if tipo == 'negativa'
      next ['Rechazada', mes] if tipo == 'rechazada'
      next ['Serología reactiva', mes] if tipo == 'reactiva'
      next ['Sin Información', mes] if tipo.nil?
    end
    donaciones.sort_by { |clave, _| clave[0] }.to_h
  end

  def donantes_por_tipo
    Donante.group(:tipo_donante).count
  end

  def predonantes_aptos
    predonantes = {}
    predonantes['Aptos'] = Donante.predonantes_aptos.count
    predonantes['Rechazados'] = Donante.predonantes_rechazados.count
    predonantes
  end

  def predonantes_recientes
    Donante.joins(:donaciones)
           .predonantes_aptos
           .where(donaciones: { fecha: 2.months.ago.beginning_of_month.. })
           .group_by_month(:fecha, format: "%B")
           .count
  end
end
