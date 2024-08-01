require 'rails_helper'

RSpec.describe Donante, type: :model do
  let(:donante) { create(:donante, :datos_completos) }

  describe "validaciones" do
    let(:donante) { create(:donante) }

    it "crear donante con correo electronico invalido falla" do
      donante.correo_electronico = "invalido"
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

  describe "#scopes" do
    describe "#sin_candidatos" do
      it "excluxe candidatos" do
        donante = create(:donante, :datos_completos, :candidato)
        expect(Donante.sin_candidatos).not_to include(donante)
      end

      it "incluye donantes sin informacion sobre candidato" do
        donante = create(:donante, :datos_completos, candidato: nil)
        expect(Donante.sin_candidatos).to include(donante)
      end

      it "incluye donantes que no son candidatos" do
        donante = create(:donante, :datos_completos, candidato: false)
        expect(Donante.sin_candidatos).to include(donante)
      end
    end

    describe "#candidatos" do
      it "incluye candidatos" do
        donante = create(:donante, :datos_completos, :candidato)
        expect(Donante.candidatos).to include(donante)
      end

      it "excluye donantes sin informacion sobre candidato" do
        donante = create(:donante, :datos_completos, candidato: nil)
        expect(Donante.candidatos).not_to include(donante)
      end

      it "excluye donantes que no son candidatos" do
        donante = create(:donante, :datos_completos, candidato: false)
        expect(Donante.candidatos).not_to include(donante)
      end
    end

    describe "#predonantes" do
      it "incluye predonantes" do
        donante = create(:donante, :datos_completos, :predonante_plaquetas)
        expect(Donante.predonantes).to include(donante)
      end

      it "excluye donantes sin informacion sobre predonante" do
        donante = create(:donante, :datos_completos, predonante_plaquetas: nil)
        expect(Donante.predonantes).not_to include(donante)
      end

      it "excluye donantes que no son predonantes" do
        donante = create(:donante, :datos_completos, predonante_plaquetas: false)
        expect(Donante.predonantes).not_to include(donante)
      end
    end

    describe "#predonantes_aptos" do
      it "incluye predonantes sin motivo de rechazo" do
        donante = create(:donante, :datos_completos, :predonante_apto)
        expect(Donante.predonantes_aptos).to include(donante)
      end

      it "excluye donantes sin informacion sobre predonante" do
        donante = create(:donante, :datos_completos, predonante_plaquetas: nil,
                                                     motivo_rechazo_predonante_plaquetas: nil)
        expect(Donante.predonantes_aptos).not_to include(donante)
      end

      it "excluye donantes que no son predonantes" do
        donante = create(:donante, :datos_completos, predonante_plaquetas: false,
                                                     motivo_rechazo_predonante_plaquetas: nil)
        expect(Donante.predonantes_aptos).not_to include(donante)
      end

      it "excluye predonantes con motivo de rechazo" do
        donante = create(:donante, :datos_completos, predonante_plaquetas: true,
                                                     motivo_rechazo_predonante_plaquetas: "motivo")
        expect(Donante.predonantes_aptos).not_to include(donante)
      end
    end

    describe "#predonantes_rechazados" do
      it "excluye predonantes sin motivo de rechazo" do
        donante = create(:donante, :datos_completos, :predonante_apto)
        expect(Donante.predonantes_rechazados).not_to include(donante)
      end

      it "excluye donantes sin informacion sobre predonante" do
        donante = create(:donante, :datos_completos, predonante_plaquetas: nil,
                                                     motivo_rechazo_predonante_plaquetas: nil)
        expect(Donante.predonantes_rechazados).not_to include(donante)
      end

      it "excluye donantes que no son predonantes" do
        donante = create(:donante, :datos_completos, predonante_plaquetas: false,
                                                     motivo_rechazo_predonante_plaquetas: nil)
        expect(Donante.predonantes_rechazados).not_to include(donante)
      end

      it "incluye predonantes con motivo de rechazo" do
        donante = create(:donante, :datos_completos, predonante_plaquetas: true,
                                                     motivo_rechazo_predonante_plaquetas: "motivo")
        expect(Donante.predonantes_rechazados).to include(donante)
      end
    end

    describe "#del_club" do
      it "incluye donantes del club" do
        donante = create(:donante, :datos_completos, tipo_donante: "club")
        expect(Donante.del_club).to include(donante)
      end

      it "excluye donantes por reposicion" do
        donante = create(:donante, :datos_completos, tipo_donante: "reposicion")
        expect(Donante.del_club).not_to include(donante)
      end

      it "excluye donantes voluntarios" do
        donante = create(:donante, :datos_completos, tipo_donante: "voluntario")
        expect(Donante.del_club).not_to include(donante)
      end
    end

    describe "#con_email" do
      it "incluye donantes con mail" do
        donante = create(:donante, :datos_completos, correo_electronico: "mail@mail.com")
        expect(Donante.con_email).to include(donante)
      end

      it "excluye donantes sin email" do
        donante = create(:donante, :datos_completos, correo_electronico: nil)
        expect(Donante.con_email).not_to include(donante)
      end
    end

    describe "#no_bloqueados" do
      it "incluye donantes no bloqueados" do
        donante = create(:donante, :datos_completos, bloqueado: false)
        expect(Donante.no_bloqueados).to include(donante)
      end

      it "excluye donantes bloqueados" do
        donante = create(:donante, :datos_completos, bloqueado: true)
        expect(Donante.no_bloqueados).not_to include(donante)
      end

      it "incluye donantes sin informacion sobre bloqueo" do
        donante = create(:donante, :datos_completos, bloqueado: nil)
        expect(Donante.no_bloqueados).to include(donante)
      end
    end

    describe "#con_exclusiones" do
      it "excluye donantes sin exclusiones" do
        expect(Donante.con_exclusiones).not_to include(donante)
      end

      it "incluye donantes con exclusiones" do
        create(:exclusion, donante: donante)
        expect(Donante.con_exclusiones).to include(donante)
      end

      it "incluye donantes con exclusiones sin fechas de fin" do
        create(:exclusion, donante: donante, fecha_fin: nil)
        expect(Donante.con_exclusiones).to include(donante)
      end

      it "excluye donantes con exclusiones finalizadas" do
        create(:exclusion, donante: donante, fecha_fin: 1.day.ago)
        expect(Donante.con_exclusiones).not_to include(donante)
      end
    end

    describe "#serologia_reactiva" do
      it "excluye donantes sin donaciones" do
        expect(Donante.serologia_reactiva).not_to include(donante)
      end

      it "excluye donantes con donaciones con serologia negativa" do
        create(:donacion, donante: donante)
        expect(Donante.serologia_reactiva).not_to include(donante)
      end

      it "incluye donantes con donaciones con serologia reactiva" do
        create(:donacion, serologia: "reactiva", donante: donante)
        expect(Donante.serologia_reactiva).to include(donante)
      end
    end

    describe "#con_donacion_rechazada" do
      it "excluye donantes sin ultima_donacion" do
        expect(Donante.con_donacion_rechazada).not_to include(donante)
      end

      it "excluye donantes con ultima donacion no rechazada" do
        create(:donacion, donante: donante)
        expect(Donante.con_donacion_rechazada).not_to include(donante)
      end

      it "incluye donantes con ultima donacion rechazada" do
        create(:donacion, :rechazada, donante: donante)
        expect(Donante.con_donacion_rechazada).to include(donante)
      end
    end

    describe "#contactados" do
      it "excluye donantes sin ultima_donacion" do
        expect(Donante.contactados(Date.new(2024, 8, 1))).not_to include(donante)
      end

      it "excluye donantes con ultima donacion reciente" do
        create(:donacion, donante: donante, fecha: Date.new(2024, 9, 1))
        expect(Donante.contactados(Date.new(2024, 8, 1))).not_to include(donante)
      end

      it "incluye donantes con ultima donacion antigua" do
        create(:donacion, donante: donante, fecha: Date.new(2020, 7, 1))
        expect(Donante.contactados(Date.new(2024, 8, 1))).to include(donante)
      end
    end
  end

  describe "#destroy" do
    it "destruye las donaciones al ser destruido" do
      create(:donacion, donante: donante)
      expect { donante.destroy! }.to change(Donacion, :count).by(-1)
    end

    it "destruye las exclusiones al ser destruido" do
      create(:exclusion, donante: donante)
      expect { donante.destroy! }.to change(Exclusion, :count).by(-1)
    end

    it "destruye las interacciones al ser destruida" do
      create(:interaccion, donante: donante)
      expect { donante.destroy! }.to change(Interaccion, :count).by(-1)
    end
  end
end
