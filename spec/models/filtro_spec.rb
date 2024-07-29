require 'rails_helper'

RSpec.describe Filtro, type: :model do
  let(:filtro) { create(:filtro_por_atributo) }

  describe "validaciones" do
    it "no puede crearse sin parametros" do
      filtro.parametros = nil
      expect(filtro).not_to be_valid
      expect(filtro.errors).to have_key(:parametros)
    end
  end

  describe "filtros" do
    it "inicializa instancias de filtros" do
      filtros = filtro.filtros
      expect(filtros.size).to eq 1
      expect(filtros.first.class).to eq FiltroPorAtributo
    end
  end

  describe "aplicar" do
    it "incluye al donante si cumple con el filtro" do
      donante = create(:donante, :datos_completos)
      expect(filtro.aplicar).to include(donante)
    end

    it "excluye al donante si no cumple con el filtro" do
      donante = create(:donante, :datos_completos, tipo_donante: "reposicion")
      expect(filtro.aplicar).not_to include(donante)
    end

    it "mezcla los filtros por defecto con los de los filtros" do
      donante = create(:donante, :datos_completos, fecha_nacimiento: "1900-1-1")
      expect(filtro.aplicar).not_to include(donante)
    end

    it "excluye al donante si ya fue contactado por la automatizacion" do
      donante = create(:donante, :datos_completos)
      automatizacion = create(:automatizacion)
      create(:interaccion, donante: donante, comunicacion: automatizacion)
      expect(filtro.aplicar(automatizacion)).not_to include(donante)
    end

    it "incluye al donante si ya fue contactado por la campaña" do
      donante = create(:donante, :datos_completos)
      campania = create(:campania)
      create(:interaccion, donante: donante, comunicacion: campania)
      expect(filtro.aplicar(campania)).to include(donante)
    end

    it "excluye candidatos por default" do
      donante = create(:donante, :datos_completos, :candidato)
      expect(filtro.aplicar).not_to include(donante)
    end

    it "incluye al candidato si el filtro incluye candidatos, a pesar del filtor default" do
      donante = create(:donante, :datos_completos, :candidato)
      filtro = create(:filtro_por_atributo, parametros: [{ tipo: "FiltroPorAtributo", atributo: "candidato",
                                                           operador: "igual", valor: "true" }])
      expect(filtro.aplicar).to include(donante)
    end
  end
end
