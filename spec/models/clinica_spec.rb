require 'rails_helper'

RSpec.describe Clinica, type: :model do
  let(:clinica) { create(:clinica) }

  it "crear clinica" do
    expect(clinica).to have_attributes(attributes_for(:clinica))
  end

  it "crear clinica con codigo duplicado falla" do
    clinica
    clinica_duplicada = build(:clinica)
    expect(clinica_duplicada).not_to be_valid
    expect(clinica_duplicada.errors).to have_key(:codigo)
  end
end
