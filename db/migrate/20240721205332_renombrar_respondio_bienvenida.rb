class RenombrarRespondioBienvenida < ActiveRecord::Migration[7.1]
  def change
    rename_column :donantes, :respondio_bienvenida, :suscripto
  end
end
