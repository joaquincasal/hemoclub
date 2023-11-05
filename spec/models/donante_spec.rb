require 'rails_helper'

RSpec.describe Donante, type: :model do
  let(:datos_obligatorios) do
    {
      apellidos: "Pérez",
      nombre: "Juan",
      tipo_documento: "DNI",
      numero_documento: "33444555",
      sexo: "M",
      fecha_nacimiento: 20.years.ago.to_date
    }
  end

  let(:datos_no_obligatorios) do
    {
      tipo_donante: "voluntario",
      fecha_ultima_donacion: Date.yesterday,
      segundo_nombre: "Iñani",
      direccion: "Av. Corrientes 900",
      codigo_postal: "1008",
      localidad: "San Nicolás",
      provincia: "Ciudad Autónoma de Buenos Aires",
      pais: "Argentina",
      telefono: "01144445555",
      correo_electronico: "mail@mail.com",
      ocupacion: "Programador",
      grupo_sanguineo: "0",
      factor: "+",
      total_donaciones_hemocentro: 3,
      fecha_primera_donacion: 2.years.ago.to_date,
      origen_candidato: "111",
      institucion: "222"
    }
  end

  let(:datos_donante) { datos_obligatorios.merge(datos_no_obligatorios) }

  it "crear donante" do
    described_class.create(datos_donante)
    expect(described_class.first).to have_attributes(datos_donante)
  end

  it "crear donante solo con datos obligatorios" do
    described_class.create(datos_obligatorios)
    expect(described_class.first).to have_attributes(datos_obligatorios)
  end

  it "crear donante falla con datos obligatorios faltantes" do
    donante = described_class.create(datos_donante.except(:numero_documento))
    expect(donante.valid?).to be false
    expect(donante.errors).to have_key(:numero_documento)
  end
end
