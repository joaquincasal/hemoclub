require 'rails_helper'

RSpec.describe ActualizarDonantesJob do
  it "actualiza un donante del club inactivo" do
    donante = create(:donante, tipo_donante: Donante.tipo_donantes[:club])
    create(:donacion, donante: donante, fecha: 2.years.ago)

    described_class.perform_now
    expect(donante.reload).to be_voluntario
  end

  it "no actualiza un donante del club activo" do
    donante = create(:donante, tipo_donante: Donante.tipo_donantes[:club])
    create(:donacion, donante: donante, fecha: 1.week.ago)

    described_class.perform_now
    expect(donante.reload).to be_club
  end
end
