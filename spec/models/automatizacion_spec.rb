require 'rails_helper'

RSpec.describe Automatizacion, type: :model do
  include ActiveJob::TestHelper

  let(:automatizacion) { create(:automatizacion) }

  describe "validaciones" do
    it "no puede crearse sin nombre" do
      automatizacion.nombre = ""
      expect(automatizacion).not_to be_valid
      expect(automatizacion.errors).to have_key(:nombre)
    end

    it "no puede crearse sin remitente" do
      automatizacion.remitente = ""
      expect(automatizacion).not_to be_valid
      expect(automatizacion.errors).to have_key(:remitente)
    end

    it "no puede crearse sin plantilla" do
      automatizacion.plantilla = nil
      expect(automatizacion).not_to be_valid
      expect(automatizacion.errors).to have_key(:plantilla)
    end

    it "no puede crearse sin lista" do
      automatizacion.lista = nil
      expect(automatizacion).not_to be_valid
      expect(automatizacion.errors).to have_key(:lista)
    end
  end

  describe "#filtrar_contactados?" do
    it "devuelve true" do
      expect(automatizacion.filtrar_contactados?).to be true
    end
  end

  describe "#enviar" do
    it "crea una ejecucion" do
      expect { automatizacion.enviar }.to change(Ejecucion, :count).by(1)
      expect(Ejecucion.last.comunicacion).to eq automatizacion
    end

    it "programa un job asincronico" do
      automatizacion.enviar
      assert_enqueued_jobs 1, only: EnviarComunicacionJob
    end
  end

  describe "#donantes" do
    it "delega en lista" do
      allow(automatizacion.lista).to receive(:donantes)
      automatizacion.donantes
      expect(automatizacion.lista).to have_received(:donantes).with(automatizacion)
    end
  end

  describe "#destroy" do
    it "no destruye la plantilla al ser destruida" do
      plantilla = automatizacion.plantilla
      automatizacion.destroy!
      expect(plantilla).not_to be_destroyed
    end

    it "no destruye la lista al ser destruida" do
      lista = automatizacion.lista
      automatizacion.destroy!
      expect(lista).not_to be_destroyed
    end

    it "destruye las ejecuciones al ser destruida" do
      create(:ejecucion, comunicacion: automatizacion)
      expect { automatizacion.destroy! }.to change(Ejecucion, :count).by(-1)
    end

    it "destruye las interacciones al ser destruida" do
      ejecucion = create(:ejecucion, comunicacion: automatizacion)
      create(:interaccion, ejecucion: ejecucion, comunicacion: automatizacion)
      expect { automatizacion.destroy! }.to change(Interaccion, :count).by(-1)
    end
  end
end
