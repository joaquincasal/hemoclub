class AgregarCandidatosADonantes < ActiveRecord::Migration[7.1]
  def change
    add_column :donantes, :candidato, :boolean
  end
end
