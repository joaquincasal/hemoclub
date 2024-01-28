class CambiarTipoClinicaId < ActiveRecord::Migration[7.1]
  def change
    change_column :donaciones, :clinica_id, :integer
  end
end
