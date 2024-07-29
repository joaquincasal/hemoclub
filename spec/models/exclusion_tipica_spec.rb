require 'rails_helper'

RSpec.describe ExclusionTipica, type: :model do
  let(:exclusion) { create(:exclusion_tipica) }

  describe "validaiones" do
    it "crear exclusion sin duracion falla" do
      exclusion.duracion = nil
      expect(exclusion).not_to be_valid
      expect(exclusion.errors).to have_key(:duracion)
    end

    it "crear exclusion sin motivo falla" do
      exclusion.motivo = ""
      expect(exclusion).not_to be_valid
      expect(exclusion.errors).to have_key(:motivo)
    end
  end
end
