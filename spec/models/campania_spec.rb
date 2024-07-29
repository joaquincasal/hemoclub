require 'rails_helper'

RSpec.describe Campania, type: :model do
  include ActiveJob::TestHelper

  let(:campania) { create(:campania) }

  describe "#filtrar_contactados?" do
    it "devuelve false" do
      expect(campania.filtrar_contactados?).to be false
    end
  end

  describe "#programar_envio" do
    it "crea una ejecucion con la fecha recibida" do
      fecha = DateTime.new(2030, 1, 1, 12, 0, 0)
      expect { campania.programar_envio(fecha) }.to change(Ejecucion, :count).by(1)
      expect(Ejecucion.last.fecha).to eq fecha
    end

    it "programa un job asincronico" do
      campania.programar_envio(1.day.from_now)
      assert_enqueued_jobs 1, only: EnviarComunicacionJob
    end
  end
end
