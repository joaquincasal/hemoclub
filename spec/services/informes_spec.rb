require 'rails_helper'

RSpec.describe Informes, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  before { travel_to(Date.new(2024, 7, 30)) }

  describe "#donantes_por_tipo" do
    before do
      create(:donante, :con_donacion, tipo_donante: "reposicion")
      create(:donante, :con_donacion, tipo_donante: "voluntario")
      create(:donante, :con_donacion, tipo_donante: "club")
      create(:donante, :con_donacion, tipo_donante: "club")
      create(:donante, :con_donacion, tipo_donante: nil)
      create(:donante, :con_donacion_vieja)
    end

    it "devuelve cantidad correcta de donantes por cada tipo" do
      resultado = Informes.donantes_por_tipo
      expect(resultado).to eq({
                                "Reposicion" => 1,
                                "Voluntario" => 1,
                                "Club" => 2,
                                "Sin información" => 1
                              })
    end
  end

  describe "#donantes_por_grupo_y_factor" do
    before do
      create(:donante, :con_donacion, grupo_sanguineo: :"0", factor: "positivo")
      create(:donante, :con_donacion, grupo_sanguineo: :"0", factor: "positivo")
      create(:donante, :con_donacion, grupo_sanguineo: :"0", factor: "negativo")
      create(:donante, :con_donacion, grupo_sanguineo: :A, factor: "positivo")
      create(:donante, :con_donacion, grupo_sanguineo: :A, factor: "negativo")
      create(:donante, :con_donacion, grupo_sanguineo: :B, factor: "positivo")
      create(:donante, :con_donacion, grupo_sanguineo: :B, factor: "negativo")
      create(:donante, :con_donacion, grupo_sanguineo: :AB, factor: "positivo")
      create(:donante, :con_donacion, grupo_sanguineo: :AB, factor: "negativo")
      create(:donante, :con_donacion, grupo_sanguineo: :A2B, factor: "positivo")
      create(:donante, :con_donacion, grupo_sanguineo: :A2B, factor: "negativo")
      create(:donante, :con_donacion, grupo_sanguineo: nil, factor: "positivo")
      create(:donante, :con_donacion, grupo_sanguineo: :AB, factor: nil)
      create(:donante, :con_donacion, grupo_sanguineo: nil, factor: nil)
      create(:donante, :con_donacion, grupo_sanguineo: :"0", factor: "positivo", candidato: true)
      create(:donante, :con_donacion_vieja, grupo_sanguineo: :"0", factor: "positivo")
    end

    it "devuelve cantidad correcta de donantes por cada combinacion de grupo y factor" do
      resultado = Informes.donantes_por_grupo_y_factor
      expect(resultado).to eq({
                                %w[positivo 0] => 2, %w[negativo 0] => 1,
                                %w[positivo A] => 1, %w[negativo A] => 1,
                                %w[positivo B] => 1, %w[negativo B] => 1,
                                %w[positivo AB] => 1, %w[negativo AB] => 1,
                                %w[positivo A2B] => 1, %w[negativo A2B] => 1
                              })
      expect(resultado.values.sum).to eq 11
    end
  end

  describe "#recurrentes" do
    before do
      voluntario_recurrente_a = create(:donante, :datos_completos)
      voluntario_recurrente_b = create(:donante, :datos_completos)
      club_recurrente = create(:donante, :datos_completos)
      reposicion = create(:donante, :datos_completos)
      voluntario_recurrente_viejo = create(:donante, :datos_completos)
      create(:donacion, fecha: 9.months.ago, donante: voluntario_recurrente_a, tipo_donante: "voluntario")
      create(:donacion, fecha: 3.months.ago, donante: voluntario_recurrente_a, tipo_donante: "voluntario")
      create(:donacion, fecha: 9.months.ago, donante: voluntario_recurrente_b, tipo_donante: "voluntario")
      create(:donacion, fecha: 3.months.ago, donante: voluntario_recurrente_b, tipo_donante: "voluntario")
      create(:donacion, fecha: 9.months.ago, donante: club_recurrente, tipo_donante: "club")
      create(:donacion, fecha: 3.months.ago, donante: club_recurrente, tipo_donante: "club")
      create(:donacion, fecha: 9.months.ago, donante: reposicion, tipo_donante: "reposicion")
      create(:donacion, fecha: 18.months.ago, donante: voluntario_recurrente_viejo, tipo_donante: "voluntario")
      create(:donacion, fecha: 14.months.ago, donante: voluntario_recurrente_viejo, tipo_donante: "voluntario")
    end

    it "devuelve cantidad correcta de donantes por cada tipo" do
      resultado = Informes.recurrentes
      expect(resultado).to eq({
                                "Voluntarios" => 2,
                                "Club" => 1
                              })
    end
  end

  describe "#fidelizados" do
    before do
      fidelizado = create(:donante, :datos_completos)
      reposicion = create(:donante, :datos_completos)
      fidelizado_viejo = create(:donante, :datos_completos)
      create(:donacion, fecha: 9.months.ago, donante: reposicion, tipo_donante: "reposicion")
      create(:donacion, fecha: 9.months.ago, donante: fidelizado, tipo_donante: "reposicion")
      create(:donacion, fecha: 3.months.ago, donante: fidelizado, tipo_donante: "voluntario")
      create(:donacion, fecha: 18.months.ago, donante: fidelizado_viejo, tipo_donante: "reposicion")
      create(:donacion, fecha: 14.months.ago, donante: fidelizado_viejo, tipo_donante: "voluntario")
    end

    it "devuelve cantidad correcta de donantes" do
      resultado = Informes.fidelizados
      expect(resultado).to eq({ "Donantes" => 1 })
    end
  end

  describe "#predonantes_aptos_vs_no_aptos" do
    before do
      create(:donante, :con_donacion, :predonante_apto)
      create(:donante, :con_donacion, :predonante_plaquetas, motivo_rechazo_predonante_plaquetas: "motivo")
      create(:donante, :con_serologia_reactiva, :predonante_apto)
      create(:donante, :con_donacion, :con_serologia_reactiva, :predonante_plaquetas,
             motivo_rechazo_predonante_plaquetas: "motivo")
      create(:donante, :con_donacion_vieja, :predonante_apto)
      create(:donante, :con_donacion, predonante_plaquetas: false, motivo_rechazo_predonante_plaquetas: nil)
      create(:donante, :con_donacion, predonante_plaquetas: false, motivo_rechazo_predonante_plaquetas: "motivo")
    end

    it "devuelve cantidad correcta de predonantes por aptitud" do
      resultado = Informes.predonantes_aptos_vs_no_aptos
      expect(resultado).to eq({
                                "Aptos" => 1,
                                "Rechazados" => 1
                              })
    end
  end

  describe "#donaciones_por_mes" do
    before do
      create(:donacion, motivo_rechazo: "motivo", serologia: nil, fecha: Date.new(2024, 7, 5))
      create(:donacion, motivo_rechazo: nil, serologia: "reactiva", fecha: Date.new(2024, 7, 5))
      create(:donacion, motivo_rechazo: nil, serologia: "negativa", fecha: Date.new(2024, 7, 5))
      create(:donacion, motivo_rechazo: nil, serologia: nil, fecha: Date.new(2024, 7, 5))
      create(:donacion, motivo_rechazo: "motivo", serologia: nil, fecha: Date.new(2024, 6, 5))
      create(:donacion, motivo_rechazo: "motivo", serologia: nil, fecha: Date.new(2024, 6, 5))
      create(:donacion, motivo_rechazo: nil, serologia: "reactiva", fecha: Date.new(2024, 6, 5))
      create(:donacion, motivo_rechazo: nil, serologia: "reactiva", fecha: Date.new(2024, 6, 5))

      create(:donacion, motivo_rechazo: nil, serologia: "reactiva", fecha: Date.new(2020, 6, 5))
    end

    it "devuelve cantidad correcta de donaciones por condición" do
      resultado = Informes.donaciones_por_mes
      expect(resultado).to eq({
                                ["Apta", "julio 2024"] => 1, ["Apta", "junio 2024"] => 0,
                                ["Rechazada", "julio 2024"] => 1, ["Rechazada", "junio 2024"] => 2,
                                ["Serología reactiva", "julio 2024"] => 1, ["Serología reactiva", "junio 2024"] => 2,
                                ["Sin información", "julio 2024"] => 1, ["Sin información", "junio 2024"] => 0
                              })
    end
  end

  describe "#donaciones_por_mes_por_tipo_donante" do
    before do
      create(:donacion, tipo_donante: "club", fecha: Date.new(2024, 7, 5))
      create(:donacion, tipo_donante: "club", fecha: Date.new(2024, 7, 5))
      create(:donacion, tipo_donante: "voluntario", fecha: Date.new(2024, 7, 5))
      create(:donacion, tipo_donante: "reposicion", fecha: Date.new(2024, 7, 5))
      create(:donacion, tipo_donante: "voluntario", fecha: Date.new(2024, 6, 5))
      create(:donacion, tipo_donante: "reposicion", fecha: Date.new(2024, 6, 5))

      create(:donacion, tipo_donante: "club", fecha: Date.new(2020, 2, 1))
      create(:donacion, tipo_donante: "club", fecha: Date.new(2024, 7, 5), motivo_rechazo: "motivo")
      create(:donacion, tipo_donante: "club", fecha: Date.new(2024, 7, 5), serologia: "reactiva")
      create(:donacion, tipo_donante: "club", fecha: Date.new(2024, 7, 5), serologia: nil)
    end

    it "devuelve cantidad correcta de donaciones por tipo de donante" do
      resultado = Informes.donaciones_por_mes_por_tipo_donante
      expect(resultado).to eq({
                                ["club", "julio 2024"] => 2, ["club", "junio 2024"] => 0,
                                ["voluntario", "julio 2024"] => 1, ["voluntario", "junio 2024"] => 1,
                                ["reposicion", "julio 2024"] => 1, ["reposicion", "junio 2024"] => 1
                              })
    end
  end

  describe "#predonantes_recientes" do
    before do
      donante_julio = create(:donante, :predonante_apto)
      donante_junio = create(:donante, :predonante_apto)
      donante_abril = create(:donante, :predonante_apto)
      create(:donacion, donante: donante_julio, fecha: Date.new(2024, 7, 2))
      create(:donacion, donante: donante_junio, fecha: Date.new(2024, 6, 2))
      create(:donacion, donante: donante_abril, fecha: Date.new(2024, 4, 2))

      create(:donante, :con_donacion, :predonante_plaquetas, motivo_rechazo_predonante_plaquetas: "motivo")
      create(:donante, :con_serologia_reactiva, :predonante_apto)
      create(:donante, :con_donacion, :con_serologia_reactiva, :predonante_plaquetas,
             motivo_rechazo_predonante_plaquetas: "motivo")
      create(:donante, :con_donacion_vieja, :predonante_apto)
      create(:donante, :con_donacion, predonante_plaquetas: false, motivo_rechazo_predonante_plaquetas: nil)
      create(:donante, :con_donacion, predonante_plaquetas: false, motivo_rechazo_predonante_plaquetas: "motivo")
    end

    it "devuelve cantidad correcta de predonantes por fecha" do
      resultado = Informes.predonantes_recientes
      expect(resultado).to eq({
                                "julio 2024" => 1,
                                "junio 2024" => 1
                              })
    end
  end

  describe "#donaciones_por_institucion" do
    before do
      clinica_a = create(:clinica, nombre: "A")
      clinica_b = create(:clinica, nombre: "B")
      create(:donacion, clinica: clinica_a)
      create(:donacion, clinica: clinica_a)
      create(:donacion, clinica: clinica_b)
      create(:donacion, clinica: clinica_b, fecha: 2.years.ago)
      create(:donacion, clinica: nil)
    end

    it "devuelve cantidad de donaciones por clinica" do
      resultado = Informes.donaciones_por_institucion
      expect(resultado).to eq({
                                "A" => 2,
                                "B" => 1,
                                "Sin institución" => 1
                              })
    end
  end

  describe "#porcentaje_emails_abiertos" do
    before do
      create(:interaccion, estado_interaccion: "enviado", estado_envio: "entregado")
      create(:interaccion, estado_interaccion: "enviado", estado_envio: "entregado")
      create(:interaccion, estado_interaccion: "enviado", estado_envio: "suprimido")
      create(:interaccion, estado_interaccion: "leido", estado_envio: "entregado")
    end

    it "devuelve la cantidad de interacciones por estado de envio" do
      resultado = Informes.porcentaje_emails_abiertos
      expect(resultado).to eq({
                                "Enviados" => 2,
                                "Leidos" => 1
                              })
    end
  end

  describe "#porcentaje_emails_entregados" do
    before do
      create(:interaccion, estado_envio: "entregado")
      create(:interaccion, estado_envio: "entregado")
      create(:interaccion, estado_envio: "suprimido")
      create(:interaccion, estado_envio: "rebotado")
      create(:interaccion, estado_envio: "cuarentena")
      create(:interaccion, estado_envio: "filtrado")
      create(:interaccion, estado_envio: "expandido")
      create(:interaccion, estado_envio: "fallido")
    end

    it "devuelve la cantidad de interacciones por estado de envio" do
      resultado = Informes.porcentaje_emails_entregados
      expect(resultado).to eq({
                                "Entregado" => 2,
                                "Suprimido" => 1,
                                "Rebotado" => 1,
                                "Cuarentena" => 1,
                                "Filtrado" => 1,
                                "Expandido" => 1,
                                "Fallido" => 1
                              })
    end
  end
end
