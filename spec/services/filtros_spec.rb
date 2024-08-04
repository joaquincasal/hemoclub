require 'rails_helper'

RSpec.describe "Filtros", type: :service do
  include ActiveSupport::Testing::TimeHelpers

  describe FiltroPorAtributo do
    describe "validaciones" do
      it "lanza excepcion al usar atributo inválido" do
        filtro = FiltroPorAtributo.new(atributo: "invalido", operador: "igual", valor: "reposicion")
        expect { filtro.aplicar }.to raise_error(ArgumentError)
      end

      it "lanza excepcion al usar operador inválido" do
        filtro = FiltroPorAtributo.new(atributo: "tipo_donante", operador: "invalido", valor: "reposicion")
        expect { filtro.aplicar }.to raise_error(ArgumentError)
      end

      it "lanza excepcion al usar operador inválido para el atributo" do
        filtro = FiltroPorAtributo.new(atributo: "tipo_donante", operador: "mayor", valor: "reposicion")
        expect { filtro.aplicar }.to raise_error(ArgumentError)
      end
    end

    describe "tipo_donante" do
      let!(:reposicion) { create(:donante, tipo_donante: "reposicion") }
      let!(:voluntario) { create(:donante, tipo_donante: "voluntario") }
      let!(:club) { create(:donante, tipo_donante: "club") }

      it "selecciona donantes por reposicion" do
        filtro = FiltroPorAtributo.new(atributo: "tipo_donante", operador: "igual", valor: "reposicion")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(reposicion)
      end

      it "selecciona donantes distintos a reposicion" do
        filtro = FiltroPorAtributo.new(atributo: "tipo_donante", operador: "distinto", valor: "reposicion")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(voluntario, club)
      end

      it "selecciona donantes voluntaarios" do
        filtro = FiltroPorAtributo.new(atributo: "tipo_donante", operador: "igual", valor: "voluntario")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(voluntario)
      end

      it "selecciona donantes distintos a voluntario" do
        filtro = FiltroPorAtributo.new(atributo: "tipo_donante", operador: "distinto", valor: "voluntario")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(reposicion, club)
      end

      it "selecciona donantes del club" do
        filtro = FiltroPorAtributo.new(atributo: "tipo_donante", operador: "igual", valor: "club")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(club)
      end

      it "selecciona donantes distintos a club" do
        filtro = FiltroPorAtributo.new(atributo: "tipo_donante", operador: "distinto", valor: "club")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(reposicion, voluntario)
      end
    end

    describe "sexo" do
      let!(:masculino) { create(:donante, sexo: "masculino") }
      let!(:femenino) { create(:donante, sexo: "femenino") }

      it "selecciona donante con sexo masculino" do
        filtro = FiltroPorAtributo.new(atributo: "sexo", operador: "igual", valor: "masculino")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(masculino)
      end

      it "selecciona donante con sexo distinto a masculino" do
        filtro = FiltroPorAtributo.new(atributo: "sexo", operador: "distinto", valor: "masculino")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(femenino)
      end

      it "selecciona donante con sexo femenino" do
        filtro = FiltroPorAtributo.new(atributo: "sexo", operador: "igual", valor: "femenino")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(femenino)
      end

      it "selecciona donante con sexo distinto a femenino" do
        filtro = FiltroPorAtributo.new(atributo: "sexo", operador: "distinto", valor: "femenino")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(masculino)
      end
    end

    describe "grupo_sanguineo" do
      let!(:cero) { create(:donante, grupo_sanguineo: "0") }
      let!(:a) { create(:donante, grupo_sanguineo: "A") }
      let!(:b) { create(:donante, grupo_sanguineo: "B") }
      let!(:ab) { create(:donante, grupo_sanguineo: "AB") }
      let!(:a2b) { create(:donante, grupo_sanguineo: "A2B") }

      it "selecciona donantes tipo 0" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "igual", valor: "0")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(cero)
      end

      it "selecciona donantes distintos a tipo 0" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "distinto", valor: "0")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 4
        expect(resultado).to include(a, b, ab, a2b)
      end

      it "selecciona donantes tipo A" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "igual", valor: "A")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(a)
      end

      it "selecciona donantes distintos a tipo A" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "distinto", valor: "A")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 4
        expect(resultado).to include(cero, b, ab, a2b)
      end

      it "selecciona donantes tipo B" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "igual", valor: "B")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(b)
      end

      it "selecciona donantes distintos a tipo B" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "distinto", valor: "B")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 4
        expect(resultado).to include(cero, a, ab, a2b)
      end

      it "selecciona donantes tipo AB" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "igual", valor: "AB")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(ab)
      end

      it "selecciona donantes distintos a tipo AB" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "distinto", valor: "AB")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 4
        expect(resultado).to include(cero, a, b, a2b)
      end

      it "selecciona donantes tipo A2B" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "igual", valor: "A2B")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(a2b)
      end

      it "selecciona donantes distintos a tipo A2B" do
        filtro = FiltroPorAtributo.new(atributo: "grupo_sanguineo", operador: "distinto", valor: "A2B")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 4
        expect(resultado).to include(cero, a, b, ab)
      end
    end

    describe "factor" do
      let!(:positivo) { create(:donante, factor: "positivo") }
      let!(:negativo) { create(:donante, factor: "negativo") }

      it "selecciona donante con factor positivo" do
        filtro = FiltroPorAtributo.new(atributo: "factor", operador: "igual", valor: "positivo")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(positivo)
      end

      it "selecciona donante con factor distinto a positivo" do
        filtro = FiltroPorAtributo.new(atributo: "factor", operador: "distinto", valor: "positivo")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(negativo)
      end

      it "selecciona donante con factor negativo" do
        filtro = FiltroPorAtributo.new(atributo: "factor", operador: "igual", valor: "negativo")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(negativo)
      end

      it "selecciona donante con factor distinto a negativo" do
        filtro = FiltroPorAtributo.new(atributo: "factor", operador: "distinto", valor: "negativo")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(positivo)
      end
    end

    describe "codigo_postal" do
      let!(:cp1234) { create(:donante, codigo_postal: "1234") }
      let!(:cp0000) { create(:donante, codigo_postal: "0000") }

      it "selecciona donante con codigo postal coincidente" do
        filtro = FiltroPorAtributo.new(atributo: "codigo_postal", operador: "igual", valor: "1234")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(cp1234)
      end

      it "selecciona donante con codigo postal no coincidente" do
        filtro = FiltroPorAtributo.new(atributo: "codigo_postal", operador: "distinto", valor: "1234")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(cp0000)
      end
    end

    describe "predonante_plaquetas" do
      let!(:predonante) { create(:donante, predonante_plaquetas: true) }
      let!(:no_predonante) { create(:donante, predonante_plaquetas: false) }

      it "selecciona donante predonante" do
        filtro = FiltroPorAtributo.new(atributo: "predonante_plaquetas", operador: "igual", valor: "true")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(predonante)
      end

      it "selecciona donante distinto a predonante" do
        filtro = FiltroPorAtributo.new(atributo: "predonante_plaquetas", operador: "distinto", valor: "true")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(no_predonante)
      end

      it "selecciona donante no predonante" do
        filtro = FiltroPorAtributo.new(atributo: "predonante_plaquetas", operador: "igual", valor: "false")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(no_predonante)
      end

      it "selecciona donante distinto a no predonante" do
        filtro = FiltroPorAtributo.new(atributo: "predonante_plaquetas", operador: "distinto", valor: "false")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(predonante)
      end
    end

    describe "candidato" do
      let!(:candidato) { create(:donante, candidato: true) }
      let!(:no_candidato) { create(:donante, candidato: false) }

      it "selecciona donante candidato" do
        filtro = FiltroPorAtributo.new(atributo: "candidato", operador: "igual", valor: "true")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(candidato)
      end

      it "selecciona donante distinto a candidato" do
        filtro = FiltroPorAtributo.new(atributo: "candidato", operador: "distinto", valor: "true")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(no_candidato)
      end

      it "selecciona donante no candidato" do
        filtro = FiltroPorAtributo.new(atributo: "candidato", operador: "igual", valor: "false")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(no_candidato)
      end

      it "selecciona donante distinto a no candidato" do
        filtro = FiltroPorAtributo.new(atributo: "candidato", operador: "distinto", valor: "false")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(candidato)
      end
    end

    describe "suscripto" do
      let!(:suscripto) { create(:donante, suscripto: true) }
      let!(:no_suscripto) { create(:donante, suscripto: false) }

      it "selecciona donante suscripto" do
        filtro = FiltroPorAtributo.new(atributo: "suscripto", operador: "igual", valor: "true")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(suscripto)
      end

      it "selecciona donante distinto a suscripto" do
        filtro = FiltroPorAtributo.new(atributo: "suscripto", operador: "distinto", valor: "true")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(no_suscripto)
      end

      it "selecciona donante no suscripto" do
        filtro = FiltroPorAtributo.new(atributo: "suscripto", operador: "igual", valor: "false")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(no_suscripto)
      end

      it "selecciona donante distinto a no suscripto" do
        filtro = FiltroPorAtributo.new(atributo: "suscripto", operador: "distinto", valor: "false")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(suscripto)
      end
    end

    describe "cantidad_donaciones" do
      before do
        @sin_donaciones = create(:donante)
        @con_una_donacion = create(:donante)
        @con_dos_donaciones = create(:donante)
        create(:donacion, donante: @con_una_donacion)
        create(:donacion, donante: @con_dos_donaciones, fecha: Date.new(2024, 1, 1))
        create(:donacion, donante: @con_dos_donaciones, fecha: Date.new(2024, 6, 1))
      end

      it "selecciona donante sin donaciones" do
        filtro = FiltroPorAtributo.new(atributo: "cantidad_donaciones", operador: "igual", valor: "0")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(@sin_donaciones)
      end

      it "selecciona donante con una donacion" do
        filtro = FiltroPorAtributo.new(atributo: "cantidad_donaciones", operador: "igual", valor: "1")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(@con_una_donacion)
      end

      it "selecciona donante con donaciones distintas a 0" do
        filtro = FiltroPorAtributo.new(atributo: "cantidad_donaciones", operador: "distinto", valor: "0")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(@con_una_donacion, @con_dos_donaciones)
      end

      it "selecciona donante con donaciones mayor a 0" do
        filtro = FiltroPorAtributo.new(atributo: "cantidad_donaciones", operador: "mayor", valor: "0")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(@con_una_donacion, @con_dos_donaciones)
      end

      it "selecciona donante con donaciones menor a 2" do
        filtro = FiltroPorAtributo.new(atributo: "cantidad_donaciones", operador: "menor", valor: "2")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(@sin_donaciones, @con_una_donacion)
      end

      it "selecciona donante con donaciones mayor o igual a 1" do
        filtro = FiltroPorAtributo.new(atributo: "cantidad_donaciones", operador: "mayor_o_igual", valor: "1")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(@con_una_donacion, @con_dos_donaciones)
      end

      it "selecciona donante con donaciones menor o igual a 1" do
        filtro = FiltroPorAtributo.new(atributo: "cantidad_donaciones", operador: "menor_o_igual", valor: "1")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(@sin_donaciones, @con_una_donacion)
      end
    end
  end

  describe FiltroPorUltimaDonacion do
    describe "validaciones" do
      it "lanza excepcion al usar atributo inválido" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "invalido", operador: "igual", valor: "reposicion")
        expect { filtro.aplicar }.to raise_error(ArgumentError)
      end

      it "lanza excepcion al usar operador inválido" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "invalido", valor: "reposicion")
        expect { filtro.aplicar }.to raise_error(ArgumentError)
      end

      it "lanza excepcion al usar operador inválido para el atributo" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "mayor", valor: "reposicion")
        expect { filtro.aplicar }.to raise_error(ArgumentError)
      end
    end

    describe "usa última donación si hay más de una" do
      before do
        @donante = create(:donante)
        create(:donacion, donante: @donante, fecha: Date.new(2024, 1, 1), tipo_donante: "reposicion")
        create(:donacion, donante: @donante, fecha: Date.new(2024, 6, 1), tipo_donante: "voluntario")
        create(:donante)
      end

      it "selecciona al donante al filtrar por voluntario" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "igual", valor: "voluntario")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(@donante)
      end
    end

    describe "tipo_donante" do
      let!(:reposicion) { create(:donacion, tipo_donante: "reposicion") }
      let!(:voluntario) { create(:donacion, tipo_donante: "voluntario") }
      let!(:club) { create(:donacion, tipo_donante: "club") }

      it "selecciona donantes con ultima donacion por reposicion" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "igual", valor: "reposicion")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(reposicion.donante)
      end

      it "selecciona donantes con ultima donacion distinto a reposicion" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "distinto", valor: "reposicion")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(voluntario.donante, club.donante)
      end

      it "selecciona donantes con ultima donacion con tipo igual a voluntario" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "igual", valor: "voluntario")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(voluntario.donante)
      end

      it "selecciona donantes con ultima donacion con tipo distinto a voluntario" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "distinto", valor: "voluntario")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(reposicion.donante, club.donante)
      end

      it "selecciona donantes con ultima donacion del club" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "igual", valor: "club")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(club.donante)
      end

      it "selecciona donantes con ultima donacion distintos a club" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "tipo_donante", operador: "distinto", valor: "club")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(reposicion.donante, voluntario.donante)
      end
    end

    describe "fecha" do
      before do
        travel_to(Date.new(2024, 7, 15))
        @donante_julio = create(:donante)
        create(:donacion, donante: @donante_julio, fecha: Date.new(2024, 7, 15))
        @donante_junio = create(:donante)
        create(:donacion, donante: @donante_junio, fecha: Date.new(2024, 1, 1))
        create(:donacion, donante: @donante_junio, fecha: Date.new(2024, 6, 1))
        @donante_marzo = create(:donante)
        create(:donacion, donante: @donante_marzo, fecha: Date.new(2024, 3, 1))
      end

      it "selecciona donante con ultima donacion hace menos de dos meses" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "fecha", operador: "mayor", valor: "2")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 2
        expect(resultado).to include(@donante_julio, @donante_junio)
      end

      it "selecciona donante con ultima donacion hace más de dos meses" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "fecha", operador: "menor", valor: "2")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(@donante_marzo)
      end

      it "selecciona donante con ultima donacion igual a hoy" do
        filtro = FiltroPorUltimaDonacion.new(atributo: "fecha", operador: "igual", valor: "0")
        resultado = filtro.aplicar
        expect(resultado.count).to eq 1
        expect(resultado).to include(@donante_julio)
      end
    end
  end

  describe FiltroPorInteraccion do
    before do
      @automatizacion = create(:automatizacion)
      @donante_movilizado = create(:donante)
      create(:interaccion, donante: @donante_movilizado, comunicacion: @automatizacion, fecha: Date.new(2024, 6, 10))
      create(:donacion, donante: @donante_movilizado, fecha: Date.new(2024, 6, 15))
      donante_solo_contactado = create(:donante)
      create(:interaccion, donante: donante_solo_contactado, comunicacion: @automatizacion,
                           fecha: Date.new(2024, 6, 10))
      donante_no_contactado = create(:donante)
      create(:donacion, donante: donante_no_contactado, fecha: Date.new(2024, 6, 15))
      donante_movilizado_tarde = create(:donante)
      create(:interaccion, donante: donante_movilizado_tarde, comunicacion: @automatizacion,
                           fecha: Date.new(2024, 6, 10))
      create(:donacion, donante: donante_movilizado_tarde, fecha: Date.new(2024, 9, 15))
    end

    it "selecciona al donante que se le envió una comunicación anterior a una donción" do
      filtro = FiltroPorInteraccion.new(atributo: @automatizacion.id)
      resultado = filtro.aplicar
      expect(resultado.count).to eq 1
      expect(resultado).to include(@donante_movilizado)
    end
  end

  describe FiltroPorCumpleanios do
    it "selecciona donantes cuando hoy es su cumpleaños" do
      travel_to(Date.new(2024, 7, 15))
      cumpleaniero = create(:donante, fecha_nacimiento: Date.new(1990, 7, 15))
      create(:donante, fecha_nacimiento: Date.new(1990, 6, 15))
      resultado = FiltroPorCumpleanios.new.aplicar
      expect(resultado.count).to eq 1
      expect(resultado).to include(cumpleaniero)
    end
  end
end
