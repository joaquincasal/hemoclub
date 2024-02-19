require 'rails_helper'

RSpec.describe Clinica, type: :model do
  let(:clinica) { create(:clinica) }

  it "crear clinica con codigo duplicado falla" do
    clinica_duplicada = build(:clinica, codigo: clinica.codigo)
    expect(clinica_duplicada).not_to be_valid
    expect(clinica_duplicada.errors).to have_key(:codigo)
  end
end
