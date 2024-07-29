require 'rails_helper'

RSpec.describe Lista, type: :model do
  let(:lista) { create(:lista) }

  describe "validaciones" do
    it "no puede crearse sin nombre" do
      lista.nombre = ""
      expect(lista).not_to be_valid
      expect(lista.errors).to have_key(:nombre)
    end

    it "no puede crearse sin plantilla" do
      lista.filtro = nil
      expect(lista).not_to be_valid
      expect(lista.errors).to have_key(:filtro)
    end
  end

  describe "#donantes" do
    it "delega en filtro" do
      allow(lista.filtro).to receive(:aplicar)
      automatizacion = create(:automatizacion)
      lista.donantes(automatizacion)
      expect(lista.filtro).to have_received(:aplicar).with(automatizacion)
    end
  end

  describe "#destroy" do
    it "destruye el filtro al ser destruida" do
      lista
      expect { lista.destroy! }.to change(Filtro, :count).by(-1)
    end

    it "no se destruye si existen comunicaciones que la referencien" do
      create(:automatizacion, lista: lista)
      expect { lista.destroy! }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
