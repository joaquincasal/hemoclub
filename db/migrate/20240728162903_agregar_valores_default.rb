class AgregarValoresDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default :donantes, :candidato, false
    change_column_default :donantes, :suscripto, false
    change_column_default :donantes, :bloqueado, false
  end
end
