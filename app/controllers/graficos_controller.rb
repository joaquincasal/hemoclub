class GraficosController < ApplicationController
  def index
    @donantes_por_tipo = donantes_por_tipo
    @donaciones_por_mes = donaciones_por_mes
    @predonantes_aptos = predonantes_aptos
    @grupo_y_factor = grupo_y_factor
    @donaciones_por_institucion = donaciones_por_institucion
    @predonantes_recientes = predonantes_recientes
    @donaciones_por_tipo_donante = donaciones_por_mes_por_tipo_donante
    @voluntarios_recurrentes = recurrentes
    @convertidos = convertidos
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

  def donaciones_por_mes_por_tipo_donante
    Donacion.group(:tipo_donante)
            .where(fecha: 1.year.ago.next_month..)
            .group_by_month(:fecha, format: "%B")
            .count
  end

  def recurrentes
    voluntarios = voluntarios_recurrentes.count
    club = club_recurrentes.count
    { voluntarios:, club: }
  end

  def convertidos
    { voluntarios: reposicion_convertidos.count }
  end

  def reposicion_convertidos
    desde = Date.today - 1.year
    hasta = Date.today
    ActiveRecord::Base.connection.execute <<-SQL
      select distinct donante_id
      from donaciones
      where fecha between '#{desde}' and '#{hasta}'
      group by donante_id, tipo_donante
      having count(case when tipo_donante = 'voluntario' or tipo_donante = 'club' then 1 else 0 end) >= 1
        and count(case when tipo_donante = 'reposicion' then 1 else 0 end) >= 1
    SQL
  end

  def voluntarios_recurrentes
    desde = Date.today - 1.year
    hasta = Date.today
    ActiveRecord::Base.connection.execute <<-SQL
      select donante_id
      from donaciones
      where fecha between '#{desde}' and '#{hasta}'
      group by donante_id, tipo_donante
      having count(case tipo_donante when 'voluntario' then 1 end) > 1
    SQL
  end

  def club_recurrentes
    desde = Date.today - 1.year
    hasta = Date.today
    ActiveRecord::Base.connection.execute <<-SQL
      select donante_id
      from donaciones
      where fecha between '#{desde}' and '#{hasta}'
      group by donante_id, tipo_donante
      having count(case tipo_donante when 'club' then 1 end) > 1
    SQL
  end
end
