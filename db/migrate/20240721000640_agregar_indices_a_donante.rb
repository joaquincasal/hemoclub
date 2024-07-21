class AgregarIndicesADonante < ActiveRecord::Migration[7.1]
  def change
    add_index :donantes, :correo_electronico
    add_index :donantes, [:tipo_documento, :numero_documento]
  end
end
