class GraficosController < ApplicationController
  def index
    @donantes_por_tipo = Donante.group(:tipo_donante).count
    @donaciones_aptas = Donacion.group(:serologia).count
    @donaciones_por_mes = Donacion.where(fecha: 1.year.ago.next_month..).group_by_month(:fecha, format: "%B").count
  end
end
