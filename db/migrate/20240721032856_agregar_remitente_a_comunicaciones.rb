class AgregarRemitenteAComunicaciones < ActiveRecord::Migration[7.1]
  def change
    add_column :comunicaciones, :remitente, :string
  end
end
