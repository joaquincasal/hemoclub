require 'rails_helper'

RSpec.describe Donacion, type: :model do
  describe "crear donacion" do
    it "crear donacion rechazada" do
      donacion = create(:donacion, :rechazada)
      expect(donacion).to have_attributes(attributes_for(:donacion, :rechazada))
    end

    describe "validaciones" do
      let(:donacion) { create(:donacion) }

      it "crear donacion con codigo de ingreso duplicado falla" do
        donacion
        donacion_duplicada = build(:donacion)
        expect(donacion_duplicada).not_to be_valid
        expect(donacion_duplicada.errors).to have_key(:codigo_ingreso)
      end

      it "crear donacion con serologia invalida falla" do
        expect { donacion.serologia = "neutral" }.to raise_error(ArgumentError)
      end
    end
  end
end
