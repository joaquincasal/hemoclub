require 'rails_helper'

RSpec.describe Donacion, type: :model do
  let(:donacion) { create(:donacion) }

  describe "crear donacion" do
    it "crear donacion rechazada" do
      donacion = create(:donacion, :rechazada)
      expect(donacion).to have_attributes(attributes_for(:donacion, :rechazada))
    end

    describe "validaciones" do
      it "crear dos donaciones con misma fecha y donante falla" do
        donacion_duplicada = build(:donacion, donante: donacion.donante)
        expect(donacion_duplicada).not_to be_valid
        expect(donacion_duplicada.errors).to have_key(:fecha)
      end

      it "crear donacion con serologia invalida falla" do
        expect { donacion.serologia = "neutral" }.to raise_error(ArgumentError)
      end
    end

    describe "#relacionado?" do
      it "devuelve true si el codigo es de una clinica" do
        donacion.clinica_id = 999
        expect(donacion.relacionado?).to be true
      end

      it "devuelve false si el codigo es de voluntario" do
        donacion.clinica_id = Donacion::CODIGO_CLINICA_CLUB
        expect(donacion.relacionado?).to be false
      end
    end

    describe "#colecta?" do
      it "devuelve true si el codigo es de una colecta" do
        donacion.clinica_id = Donacion::CODIGO_CLINICA_COLECTA
        expect(donacion.colecta?).to be true
      end

      it "devuelve false si el codigo no es de colecta" do
        donacion.clinica_id = 999
        expect(donacion.colecta?).to be false
      end
    end

    describe "#rechazada?" do
      it "devuelve true si hay motivo de rechazo" do
        donacion.motivo_rechazo = "motivo"
        expect(donacion.rechazada?).to be true
      end

      it "devuelve false si no hay motivo de rechazo" do
        donacion.motivo_rechazo = nil
        expect(donacion.rechazada?).to be false
      end
    end

    describe "#apta?" do
      it "devuelve true si no hay motivo de rechazo y la serologia es negativa" do
        donacion.motivo_rechazo = nil
        donacion.serologia = Donacion.serologia[:negativa]
        expect(donacion.apta?).to be true
      end

      it "devuelve false si hay motivo de rechazo" do
        donacion.motivo_rechazo = "rechazo"
        donacion.serologia = Donacion.serologia[:negativa]
        expect(donacion.apta?).to be false
      end

      it "devuelve false si la serologia es negativa" do
        donacion.motivo_rechazo = nil
        donacion.serologia = Donacion.serologia[:positiva]
        expect(donacion.apta?).to be false
      end
    end
  end
end
