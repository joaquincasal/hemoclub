require 'rails_helper'

RSpec.describe Donante, type: :model do
  describe "crear donante" do
    let(:donante) { create(:donante, :datos_completos) }

    it "crear donante" do
      expect(donante).to have_attributes(attributes_for(:donante, :datos_completos))
    end

    describe "validaciones" do
      let(:donante) { create(:donante) }

      it "crear donante solo con datos obligatorios" do
        expect(donante).to have_attributes(attributes_for(:donante))
      end

      it "crear donante falla con datos obligatorios faltantes" do
        donante.numero_documento = nil
        expect(donante.valid?).to be false
        expect(donante.errors).to have_key(:numero_documento)
      end

      it "crear donante con correo electronico invalido, no guarda correo electronico" do
        donante.correo_electronico = "email"
        donante.save!
        expect(donante.reload.valid?).to be true
        expect(donante.reload.correo_electronico).to be_nil
      end

      it "crear donante con dni duplicado falla" do
        donante
        donante_duplicado = build(:donante)
        expect(donante_duplicado).not_to be_valid
        expect(donante_duplicado.errors).to have_key(:numero_documento)
      end

      it "crear donante con correo electronico duplicado falla" do
        donante
        donante_duplicado = build(:donante)
        expect(donante_duplicado).not_to be_valid
        expect(donante_duplicado.errors).to have_key(:correo_electronico)
      end

      it "crear donante con tipo_donante invalido falla" do
        expect { donante.tipo_donante = "ocasional" }.to raise_error(ArgumentError)
      end

      it "crear donante con tipo_documento invalido falla" do
        expect { donante.tipo_documento = "invalido" }.to raise_error(ArgumentError)
      end

      it "crear donante con sexo invalido falla" do
        expect { donante.sexo = "invalido" }.to raise_error(ArgumentError)
      end

      it "crear donante con grupo_sanguineo invalido falla" do
        expect { donante.grupo_sanguineo = "C" }.to raise_error(ArgumentError)
      end

      it "crear donante con factor invalido falla" do
        expect { donante.factor = "neutral" }.to raise_error(ArgumentError)
      end
    end
  end
end
