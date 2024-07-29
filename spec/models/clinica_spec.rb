require 'rails_helper'

RSpec.describe Clinica, type: :model do
  let(:clinica) { create(:clinica) }

  describe "validaciones" do
    it "no puede crearse sin nombre" do
      clinica.nombre = ""
      expect(clinica).not_to be_valid
      expect(clinica.errors).to have_key(:nombre)
    end

    it "no puede crearse sin codigo" do
      clinica.codigo = nil
      expect(clinica).not_to be_valid
      expect(clinica.errors).to have_key(:codigo)
    end

    it "crear clinica con codigo duplicado falla" do
      clinica_duplicada = build(:clinica, codigo: clinica.codigo)
      expect(clinica_duplicada).not_to be_valid
      expect(clinica_duplicada.errors).to have_key(:codigo)
    end
  end

  describe "#destroy" do
    it "marca como null las referencias de donaciones" do
      donacion = create(:donacion, clinica: clinica)
      clinica.destroy!
      expect(donacion.reload.clinica).to be_nil
    end
  end
end
