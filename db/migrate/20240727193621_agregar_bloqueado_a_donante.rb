class AgregarBloqueadoADonante < ActiveRecord::Migration[7.1]
  def change
    add_column :donantes, :bloqueado, :boolean
  end
end
