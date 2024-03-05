require 'rails_helper'

RSpec.describe Exclusion, type: :model do
  it "crear exclusoin sin fecha de inicio falla" do
    exclusion = build(:exclusion, fecha_inicio: nil)
    expect(exclusion).not_to be_valid
    expect(exclusion.errors).to have_key(:fecha_inicio)
  end

  it "crear exclusoin con fecha de inicio posterior a fecha de fin falla" do
    exclusion = build(:exclusion, fecha_inicio: "2024-2-2", fecha_fin: "2024-2-1")
    expect(exclusion).not_to be_valid
    expect(exclusion.errors).to have_key(:fecha_fin)
  end

  it "crear exclusoin sin motivo falla" do
    exclusion = build(:exclusion, motivo: "")
    expect(exclusion).not_to be_valid
    expect(exclusion.errors).to have_key(:motivo)
  end
end
