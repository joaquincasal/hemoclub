require 'rails_helper'

RSpec.describe EnviarEmailJob do
  let(:ejecucion) { create(:ejecucion, ejecutada: false) }
  let(:donante) { create(:donante) }

  it "llama al mailer para el donante" do
    mailer_double = instance_double(Mailer)
    allow(mailer_double).to receive(:enviar)
    allow(Mailer).to receive(:new).and_return(mailer_double)
    described_class.perform_now(ejecucion.comunicacion.plantilla.id, donante.id, ejecucion.id)

    expect(Mailer).to have_received(:new).with(donante, ejecucion.comunicacion.plantilla,
                                               ejecucion.comunicacion.remitente)
    expect(mailer_double).to have_received(:enviar)
  end

  it "no crea una interaccion si el mailer no devuelve el id del mensaje" do
    mailer_double = instance_double(Mailer)
    allow(mailer_double).to receive(:enviar).and_return(false)
    allow(Mailer).to receive(:new).and_return(mailer_double)
    expect { described_class.perform_now(ejecucion.comunicacion.plantilla.id, donante.id, ejecucion.id) }
      .not_to change(Interaccion, :count)
  end

  it "crea una interaccion si el mailer no devuelve el id del mensaje" do
    mailer_double = instance_double(Mailer)
    allow(mailer_double).to receive(:enviar).and_return("mensaje-id")
    allow(Mailer).to receive(:new).and_return(mailer_double)
    expect { described_class.perform_now(ejecucion.comunicacion.plantilla.id, donante.id, ejecucion.id) }
      .to change(Interaccion, :count).by(1)
  end
end
