class CrearDonantes < ActiveRecord::Migration[7.1]
  def change
    create_table :donantes do |t|
      t.integer :tipo_donante
      t.string :apellidos
      t.string :nombre
      t.string :segundo_nombre
      t.integer :tipo_documento
      t.string :numero_documento
      t.integer :sexo
      t.date :fecha_nacimiento
      t.string :telefono
      t.string :correo_electronico
      t.string :ocupacion
      t.integer :grupo_sanguineo
      t.integer :factor
      t.string :direccion
      t.string :codigo_postal
      t.string :localidad
      t.string :provincia
      t.string :pais

      t.timestamps
    end
  end
end
