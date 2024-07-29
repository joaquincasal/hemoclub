class InformesController < ApplicationController
  def index
    @donantes_por_tipo = Informes.donantes_por_tipo
    @donaciones_por_mes = Informes.donaciones_por_mes
    @predonantes_aptos_vs_no_aptos = Informes.predonantes_aptos_vs_no_aptos
    @donantes_por_grupo_y_factor = Informes.donantes_por_grupo_y_factor
    @donaciones_por_institucion = Informes.donaciones_por_institucion
    @predonantes_recientes = Informes.predonantes_recientes
    @donaciones_por_tipo_donante = Informes.donaciones_por_mes_por_tipo_donante
    @voluntarios_recurrentes = Informes.recurrentes
    @convertidos = Informes.convertidos
    @porcentaje_emails_abiertos = Informes.porcentaje_emails_abiertos
    @porcentaje_emails_entregados = Informes.porcentaje_emails_entregados
  end
end
