class Informes
  def self.donantes_por_tipo
    Donante.para_informes.group(:tipo_donante).count
           .transform_keys({ nil => "Sin información" })
           .transform_keys(&:upcase_first)
  end

  def self.donantes_por_grupo_y_factor
    Donante.para_informes.where.not(factor: nil).where.not(grupo_sanguineo: nil).group(:factor, :grupo_sanguineo).count
  end

  def self.recurrentes
    voluntarios = voluntarios_recurrentes.count
    club = club_recurrentes.count
    { "Voluntarios" => voluntarios, "Club" => club }
  end

  def self.fidelizados
    { "Donantes" => reposicion_convertidos.count }
  end

  def self.predonantes_aptos_vs_no_aptos
    predonantes = {}
    predonantes['Aptos'] = Donante.para_informes.predonantes_aptos.count
    predonantes['Rechazados'] = Donante.para_informes.predonantes_rechazados.count
    predonantes
  end

  def self.donaciones_por_mes
    donaciones = Donacion.no_rechazadas
                         .group(:serologia)
                         .where(fecha: 1.year.ago.next_month.beginning_of_month..)
                         .group_by_month(:fecha, format: "%B %Y", time_zone: false)
                         .count
    rechazadas = Donacion.rechazadas
                         .where(fecha: 1.year.ago.next_month.beginning_of_month..)
                         .group_by_month(:fecha, format: "%B %Y", time_zone: false)
                         .count
    rechazadas.each do |mes, valor|
      donaciones[['rechazada', mes]] = valor
    end
    donaciones.transform_keys! do |tipo, mes|
      next ['Apta', mes] if tipo == 'negativa'
      next ['Rechazada', mes] if tipo == 'rechazada'
      next ['Serología reactiva', mes] if tipo == 'reactiva'
      next ['Sin información', mes] if tipo.nil?
    end
    donaciones.sort_by { |clave, _| clave[0] }.to_h
  end

  def self.donaciones_por_mes_por_tipo_donante
    Donacion.negativa.no_rechazadas.group(:tipo_donante)
            .where(fecha: 1.year.ago.next_month.beginning_of_month..)
            .group_by_month(:fecha, format: "%B %Y", time_zone: false)
            .in_order_of(:tipo_donante, [:reposicion, :voluntario, :club])
            .count
  end

  def self.predonantes_recientes
    Donante.para_informes
           .joins(:ultima_donacion)
           .predonantes_aptos
           .where(ultima_donacion: { fecha: 2.months.ago.beginning_of_month.. })
           .group_by_month(:fecha, format: "%B %Y", time_zone: false)
           .count
  end

  def self.donaciones_por_institucion
    Donacion.negativa.no_rechazadas.ultimo_anio.left_outer_joins(:clinica)
            .group('clinicas.nombre').order(count: :desc).count.transform_keys({ nil => "Sin institución" })
  end

  def self.porcentaje_emails_abiertos
    {
      "Enviados" => Interaccion.entregado.enviado.count,
      "Leidos" => Interaccion.leido.count
    }
  end

  def self.porcentaje_emails_entregados
    Interaccion.estado_envios.keys.each_with_object({}) do |estado, estados|
      estados[estado.humanize] = Interaccion.public_send(estado).count
      estados
    end
  end

  def self.reposicion_convertidos
    Donacion.ultimo_anio.group(:donante_id)
            .having("sum(case when tipo_donante = 'voluntario' or tipo_donante = 'club' then 1 else 0 end) >= 1")
            .having("sum(case when tipo_donante = 'reposicion' then 1 else 0 end) >= 1")
            .count
  end

  def self.voluntarios_recurrentes
    Donacion.ultimo_anio.group(:donante_id,
                               :tipo_donante).having("count(case tipo_donante when 'voluntario' then 1 end) > 1").count
  end

  def self.club_recurrentes
    Donacion.ultimo_anio.group(:donante_id,
                               :tipo_donante).having("count(case tipo_donante when 'club' then 1 end) > 1").count
  end
end
