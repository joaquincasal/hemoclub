require 'rails_helper'

RSpec.describe EnviarComunicacionJob do
  let!(:ejecucion) { create(:ejecucion, ejecutada: false) }
  let!(:donantes) { create_list(:donante, 2, :datos_completos) }

  it "encola un job de enviar email por cada donante" do
    allow(EnviarEmailJob).to receive(:perform_later)
    described_class.perform_now(ejecucion.id)

    expect(EnviarEmailJob).to have_received(:perform_later).twice
    expect(EnviarEmailJob).to have_received(:perform_later).with(ejecucion.comunicacion.plantilla.id,
                                                                 donantes.first.id, ejecucion.id)
    expect(EnviarEmailJob).to have_received(:perform_later).with(ejecucion.comunicacion.plantilla.id, donantes.last.id,
                                                                 ejecucion.id)
  end

  it "marca la ejecucion como ejecutada" do
    described_class.perform_now(ejecucion.id)
    expect(ejecucion.reload.ejecutada).to be true
  end
end
