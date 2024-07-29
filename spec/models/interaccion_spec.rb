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
