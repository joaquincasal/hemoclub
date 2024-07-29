require 'rails_helper'

RSpec.describe Exclusion, type: :model do
  let(:exclusion) { create(:exclusion) }

  describe "validaiones" do
    it "crear exclusion sin fecha de inicio falla" do
      exclusion.fecha_inicio = nil
      expect(exclusion).not_to be_valid
      expect(exclusion.errors).to have_key(:fecha_inicio)
    end

    it "crear exclusion con fecha de inicio posterior a fecha de fin falla" do
      exclusion.fecha_inicio = "2024-2-2"
      exclusion.fecha_fin = "2024-2-1"
      expect(exclusion).not_to be_valid
      expect(exclusion.errors).to have_key(:fecha_fin)
    end

    it "crear exclusion sin motivo falla" do
      exclusion.motivo = ""
      expect(exclusion).not_to be_valid
      expect(exclusion.errors).to have_key(:motivo)
    end

    it "no puede crearse sin donante" do
      exclusion.donante = nil
      expect(exclusion).not_to be_valid
      expect(exclusion.errors).to have_key(:donante)
    end
  end
end
