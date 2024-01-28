class GraficosController < ApplicationController
  def index
    @donantes_por_tipo = Donante.group(:tipo_donante).count
    @donaciones_aptas = Donacion.no_rechazadas.group(:serologia).count
    @donaciones_aptas['sin información'] = @donaciones_aptas.delete nil
    @donaciones_por_mes = Donacion.where(fecha: 1.year.ago.next_month..).group_by_month(:fecha, format: "%B").count
  end
end
