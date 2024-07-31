require 'rails_helper'

RSpec.describe Interaccion, type: :model do
  let(:interaccion) { create(:interaccion) }

  describe "validaciones" do
    it "no puede crearse sin donante" do
      interaccion.donante = nil
      expect(interaccion).not_to be_valid
      expect(interaccion.errors).to have_key(:donante)
    end

    it "no puede crearse sin ejecucion" do
      interaccion.ejecucion = nil
      expect(interaccion).not_to be_valid
      expect(interaccion.errors).to have_key(:ejecucion)
    end

    it "no puede crearse sin comunicacion" do
      interaccion.comunicacion = nil
      expect(interaccion).not_to be_valid
      expect(interaccion.errors).to have_key(:comunicacion)
    end

    it "no puede crearse sin fecha" do
      interaccion.fecha = nil
      expect(interaccion).not_to be_valid
      expect(interaccion.errors).to have_key(:fecha)
    end

    it "puede crearse sin donacion" do
      interaccion.donacion = nil
      expect(interaccion).to be_valid
    end
  end

  describe "#contactos_ultimas_donaciones" do
    it "incluye al donante si ya fue contactado por la comunicacion" do
      donante_a = create(:donante, :datos_completos, :con_donacion)
      donante_b = create(:donante, :datos_completos)
      donante_c = create(:donante, :datos_completos, :con_donacion)
      donante_d = create(:donante, :datos_completos)
      automatizacion = create(:automatizacion)
      create(:interaccion, donante: donante_a, comunicacion: automatizacion)
      create(:interaccion, donante: donante_b, comunicacion: automatizacion)
      expect(Interaccion.contactos_ultimas_donaciones(automatizacion)).to include(donante_a.interacciones.first)
      expect(Interaccion.contactos_ultimas_donaciones(automatizacion)).to include(donante_b.interacciones.first)
      expect(Interaccion.contactos_ultimas_donaciones(automatizacion)).not_to include(donante_c.interacciones.first)
      expect(Interaccion.contactos_ultimas_donaciones(automatizacion)).not_to include(donante_d.interacciones.first)
    end

    it "no incluye al donante si ya fue contactado por la comunicacion pero por otra donacion" do
      donante = create(:donante, :datos_completos, :con_donacion)
      create(:donacion, donante: donante, fecha: 6.months.ago)
      automatizacion = create(:automatizacion)
      create(:interaccion, donante: donante, comunicacion: automatizacion, donacion: donante.ultima_donacion,
                           fecha: 5.months.ago)
      create(:donacion, donante: donante, fecha: 3.months.ago)
      expect(Interaccion.contactos_ultimas_donaciones(automatizacion)).not_to include(donante.interacciones.first)
    end
  end

  describe "#marcar_leido" do
    it "actualiza el estado de interaccion" do
      expect { interaccion.marcar_leido }.to change(interaccion, :estado_interaccion)
        .from(nil)
        .to("leido")
    end
  end

  describe "#actualizar_estado_envio" do
    it "bloquear al usuario si no se entregó el mensaje" do
      expect(interaccion.donante.bloqueado).to be false
      interaccion.actualizar_estado_envio(Interaccion.estado_envios[:fallido])
      expect(interaccion.donante.bloqueado).to be true
      expect(interaccion.estado_envio).to eq("fallido")
    end
  end
end
