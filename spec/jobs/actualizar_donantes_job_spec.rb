require 'rails_helper'

RSpec.describe ActualizarDonantesJob do
  it "actualiza los donantes correctos" do
    donante_activo = create(:donante, tipo_donante: Donante.tipo_donantes[:club])
    donante_inactivo = create(:donante, tipo_donante: Donante.tipo_donantes[:club])
    create(:donacion, donante: donante_activo, fecha: 1.week.ago)
    create(:donacion, donante: donante_inactivo, fecha: 2.years.ago)

    described_class.perform_now
    expect(donante_activo.reload).to be_club
    expect(donante_inactivo.reload).to be_voluntario
  end
end
