class InformesController < ApplicationController
  def index
    @donantes_por_tipo = Informes.donantes_por_tipo
    @donantes_por_grupo_y_factor = Informes.donantes_por_grupo_y_factor
    @recurrentes = Informes.recurrentes
    @fidelizados = Informes.fidelizados
    @predonantes_aptos_vs_no_aptos = Informes.predonantes_aptos_vs_no_aptos

    @donaciones_por_mes = Informes.donaciones_por_mes
    @donaciones_por_tipo_donante = Informes.donaciones_por_mes_por_tipo_donante
    @predonantes_recientes = Informes.predonantes_recientes
    @donaciones_por_institucion = Informes.donaciones_por_institucion

    @porcentaje_emails_abiertos = Informes.porcentaje_emails_abiertos
    @porcentaje_emails_entregados = Informes.porcentaje_emails_entregados
  end
end
