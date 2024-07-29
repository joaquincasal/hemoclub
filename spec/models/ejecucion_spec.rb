require 'rails_helper'

RSpec.describe Ejecucion, type: :model do
  let(:ejecucion) { create(:ejecucion) }

  describe "validaciones" do
    it "no puede crearse sin comunicacoin" do
      ejecucion.comunicacion = nil
      expect(ejecucion).not_to be_valid
      expect(ejecucion.errors).to have_key(:comunicacion)
    end
  end

  describe "#destroy" do
    it "destruye las interacciones" do
      create(:interaccion, ejecucion: ejecucion)
      expect { ejecucion.destroy! }.to change(Interaccion, :count).by(-1)
    end
  end
end
