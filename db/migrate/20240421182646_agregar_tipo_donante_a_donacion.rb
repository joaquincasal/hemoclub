class AgregarTipoDonanteADonacion < ActiveRecord::Migration[7.1]
  def change
    add_column :donaciones, :tipo_donante, :string
  end
end
