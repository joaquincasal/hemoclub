class CreateDonantes < ActiveRecord::Migration[7.1]
  def change
    create_table :donantes do |t|
      t.string :tipo_donante
      t.date :fecha_ultima_donacion
      t.string :apellidos
      t.string :nombre
      t.string :segundo_nombre
      t.string :tipo_documento
      t.string :numero_documento
      t.string :sexo
      t.date :fecha_nacimiento
      t.string :direccion
      t.string :codigo_postal
      t.string :localidad
      t.string :provincia
      t.string :pais
      t.string :telefono
      t.string :correo_electronico
      t.string :ocupacion
      t.string :grupo_sanguineo
      t.string :factor
      t.integer :total_donaciones_hemocentro
      t.date :fecha_primera_donacion
      t.string :origen_candidato
      t.string :institucion

      t.timestamps
    end
  end
end
