require 'rails_helper'

RSpec.describe Donante, type: :model do
  describe "crear donante" do
    let(:donante) { create(:donante, :datos_completos) }

    describe "validaciones" do
      let(:donante) { create(:donante) }

      it "crear donante con correo electronico invalido, no guarda correo electronico" do
        donante.correo_electronico = "email"
        donante.save
        expect(donante).not_to be_valid
        expect(donante.errors).to have_key(:correo_electronico)
      end

      it "crear donante con dni duplicado falla" do
        donante_duplicado = build(:donante, numero_documento: donante.numero_documento)
        expect(donante_duplicado).not_to be_valid
        expect(donante_duplicado.errors).to have_key(:numero_documento)
      end

      it "crear donante con correo electronico duplicado falla" do
        donante_duplicado = build(:donante, correo_electronico: donante.correo_electronico)
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
