require 'rails_helper'

RSpec.describe Plantilla, type: :model do
  let(:plantilla) { create(:plantilla) }

  describe "validaciones" do
    it "no puede crearse sin nombre" do
      plantilla.nombre = ""
      expect(plantilla).not_to be_valid
      expect(plantilla.errors).to have_key(:nombre)
    end

    it "no puede crearse sin contenido" do
      plantilla.contenido = nil
      expect(plantilla).not_to be_valid
      expect(plantilla.errors).to have_key(:contenido)
    end

    it "no puede crearse sin asunto si no es reutilizable" do
      plantilla.reutilizable = false
      plantilla.asunto = nil
      expect(plantilla).not_to be_valid
      expect(plantilla.errors).to have_key(:asunto)
    end

    it "puede crearse sin asunto si es reutilizable" do
      plantilla.reutilizable = true
      plantilla.asunto = nil
      expect(plantilla).to be_valid
    end
  end

  describe "#contenido_completo" do
    it "concatena el contenido del encabezado y la firma" do
      encabezado = create(:plantilla, reutilizable: true, contenido: "encabezado")
      firma = create(:plantilla, reutilizable: true, contenido: "firma")
      plantilla.encabezado = encabezado
      plantilla.firma = firma
      resultado = ActionController::Base.helpers.sanitize(encabezado.contenido + plantilla.contenido + firma.contenido)
      expect(plantilla.contenido_completo).to eq(resultado)
    end
  end

  describe "#contenido_reemplazado" do
    let(:donante) { create(:donante, :con_donacion) }

    it "elimina variables desconocidas" do
      plantilla.contenido = "Hola {{variable}}"
      resultado = ActionController::Base.helpers.sanitize("Hola ")
      expect(plantilla.contenido_reemplazado(donante)).to eq(resultado)
    end

    it "reemplaza variables de atributos del donante" do
      plantilla.contenido = "Hola {{nombre}}"
      resultado = ActionController::Base.helpers.sanitize("Hola #{donante.nombre}")
      expect(plantilla.contenido_reemplazado(donante)).to eq(resultado)
    end

    it "reemplaza variables de cantidad de donaciones" do
      plantilla.contenido = "Hola {{cantidad_donaciones}}"
      resultado = ActionController::Base.helpers.sanitize("Hola #{donante.donaciones_count}")
      expect(plantilla.contenido_reemplazado(donante)).to eq(resultado)
    end

    it "reemplaza variables de fecha de última donacion" do
      plantilla.contenido = "Hola {{fecha_ultima_donacion}}"
      resultado = ActionController::Base.helpers.sanitize("Hola #{donante.ultima_donacion.fecha&.strftime('%d/%m/%Y')}")
      expect(plantilla.contenido_reemplazado(donante)).to eq(resultado)
    end

    it "reemplaza variables de link de suscripcion" do
      plantilla.contenido = "Hola {{link_recibir_recordatorios}}"
      expect(plantilla.contenido_reemplazado(donante)).to include("Quiero recibir recordatorios")
    end

    it "reemplaza variables de link de dessuscripcion" do
      plantilla.contenido = "Hola {{link_desuscribir}}"
      expect(plantilla.contenido_reemplazado(donante)).to include("Desuscribirme")
    end
  end

  describe "#destroy" do
    it "no se destruye si existen comunicaciones que la referencien" do
      create(:automatizacion, plantilla: plantilla)
      expect { plantilla.destroy! }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
