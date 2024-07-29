require 'rails_helper'

RSpec.describe EnviarAutomatizacionesJob do
  it "llama a #enviar en automatizaciones activas" do
    create(:automatizacion, activa: true)
    allow_any_instance_of(Automatizacion).to receive(:enviar)
    expect_any_instance_of(Automatizacion).to receive(:enviar)

    described_class.perform_now
  end

  it "no llama a #enviar en automatizaciones inactivas" do
    automatizacion = create(:automatizacion, activa: false)
    allow(automatizacion).to receive(:enviar)

    described_class.perform_now
    expect(automatizacion).not_to have_received(:enviar)
  end
end
