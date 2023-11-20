# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_20_212811) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clinicas", primary_key: "codigo", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donaciones", force: :cascade do |t|
    t.string "codigo_ingreso"
    t.date "fecha"
    t.integer "serologia"
    t.boolean "predonante_plaquetas"
    t.string "motivo_rechazo"
    t.string "motivo_rechazo_predonante_plaquetas"
    t.string "origen_candidato"
    t.bigint "donante_id"
    t.bigint "clinica_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinica_id"], name: "index_donaciones_on_clinica_id"
    t.index ["donante_id"], name: "index_donaciones_on_donante_id"
  end

  create_table "donantes", force: :cascade do |t|
    t.integer "tipo_donante"
    t.string "apellidos"
    t.string "nombre"
    t.string "segundo_nombre"
    t.integer "tipo_documento"
    t.string "numero_documento"
    t.integer "sexo"
    t.date "fecha_nacimiento"
    t.string "telefono"
    t.string "correo_electronico"
    t.string "ocupacion"
    t.integer "grupo_sanguineo"
    t.integer "factor"
    t.string "direccion"
    t.string "codigo_postal"
    t.string "localidad"
    t.string "provincia"
    t.string "pais"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  end

end
