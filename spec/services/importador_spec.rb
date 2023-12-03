require 'rails_helper'

RSpec.describe Importador, type: :service do
  subject(:importacion) { described_class.new.importar(temporal) }

  let(:temporal) do
    temporal = Tempfile.new("prueba.csv")
    temporal.write(csv)
    temporal.close
    temporal.path
  end
  let(:csv) { generar_csv(datos_archivo) }
  let(:datos_archivo) { build(:importacion) }

  it "importar archivo crea un donante y una donación" do
    expect { importacion }
      .to change(Donante, :count).by(1)
      .and change(Donacion, :count).by(1)
  end

  context "cuando la donación es autologa" do
    let(:datos_archivo) { build(:importacion, :autologa) }

    it "la donación no se importa" do
      expect { importacion }
        .to not_change(Donante, :count)
        .and not_change(Donacion, :count)
    end
  end

  context "cuando la donación es un préstamo" do
    let(:datos_archivo) { build(:importacion, :prestamo) }

    it "la donación no se importa" do
      expect { importacion }
        .to not_change(Donante, :count)
        .and not_change(Donacion, :count)
    end
  end

  context "cuando el donante ya existe" do
    context "con el mismo documento" do
      before do
        create(:donante, tipo_documento: datos_archivo[:TipoDoc], numero_documento: datos_archivo[:NroDoc],
                         sexo: datos_archivo[:Sexo] == "M" ? "masculino" : "femenino", ocupacion: "Plomero")
      end

      it "el donante no se crea pero la donación sí" do
        expect { importacion }
          .to not_change(Donante, :count)
          .and change(Donacion, :count).by(1)
      end

      it "se actualiza la información del donante" do
        importacion
        expect(Donante.first.ocupacion).to eq(datos_archivo[:Ocupacion])
      end

      it "no se actualiza si no hay información nueva" do
        datos_archivo[:Ocupacion] = ""
        importacion
        expect(Donante.first.ocupacion).to eq("Plomero")
      end
    end

    context "con el mismo correo electrónico" do
      before do
        create(:donante, correo_electronico: datos_archivo[:Email])
      end

      it "el donante no se crea pero la donación sí" do
        expect { importacion }
          .to not_change(Donante, :count)
          .and change(Donacion, :count).by(1)
      end
    end
  end

  describe "separación de nombre" do
    it "separa el nombre en apellido y nombres" do
      importacion
      apellido, nombre = datos_archivo[:Nombre].split
      expect(Donante.first.nombre).to eq nombre
      expect(Donante.first.apellidos).to eq apellido
    end
  end

  describe "con caracteristicas específicas" do
    context "con tipo donante .Común" do
      let(:datos_archivo) { build(:importacion, :reposicion) }

      it "crea un donante de reposición" do
        importacion
        expect(Donante.first.reposicion?).to be true
      end
    end

    context "con tipo donante del club de donantes" do
      let(:datos_archivo) { build(:importacion, :club) }

      it "crea un donante del club de donantes" do
        importacion
        expect(Donante.first.club?).to be true
      end
    end

    context "con tipo donante voluntario" do
      let(:datos_archivo) { build(:importacion, :voluntario) }

      it "crea un donante de voluntario" do
        importacion
        expect(Donante.first.voluntario?).to be true
      end
    end

    context "con sexo masculino" do
      let(:datos_archivo) { build(:importacion, Sexo: "M") }

      it "crea un donante de con sexo masculino" do
        importacion
        expect(Donante.first.masculino?).to be true
      end
    end

    context "con sexo femenino" do
      let(:datos_archivo) { build(:importacion, Sexo: "F") }

      it "crea un donante de con sexo femenino" do
        importacion
        expect(Donante.first.femenino?).to be true
      end
    end

    context "con RH positivo" do
      let(:datos_archivo) { build(:importacion, Rh: "+") }

      it "crea un donante con factor positivo" do
        importacion
        expect(Donante.first.positivo?).to be true
      end
    end

    context "con RH negativo" do
      let(:datos_archivo) { build(:importacion, Rh: "-") }

      it "crea un donante con factor positivo" do
        importacion
        expect(Donante.first.negativo?).to be true
      end
    end

    context "con serologia negativa" do
      let(:datos_archivo) { build(:importacion, Serologia: "-") }

      it "crea una donacion con serologia negativa" do
        importacion
        expect(Donacion.first.negativa?).to be true
      end
    end

    context "con serologia reactiva" do
      let(:datos_archivo) { build(:importacion, :serologia_reactiva) }

      it "crea una donacion con serologia reactiva" do
        importacion
        expect(Donacion.first.reactiva?).to be true
      end
    end
  end

  def generar_csv(datos_archivo)
    CSV.generate do |csv|
      csv << datos_archivo.keys
      csv << datos_archivo.values
    end
  end
end
