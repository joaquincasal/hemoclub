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

ActiveRecord::Schema[7.1].define(version: 2024_07_21_205332) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "clinicas", primary_key: "codigo", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comunicaciones", force: :cascade do |t|
    t.string "nombre"
    t.bigint "lista_id", null: false
    t.bigint "plantilla_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activa", default: true
    t.string "type"
    t.string "remitente"
    t.index ["lista_id"], name: "index_comunicaciones_on_lista_id"
    t.index ["plantilla_id"], name: "index_comunicaciones_on_plantilla_id"
  end

  create_table "donaciones", force: :cascade do |t|
    t.date "fecha"
    t.integer "serologia"
    t.integer "motivo_rechazo"
    t.bigint "donante_id"
    t.integer "clinica_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo_donante"
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
    t.boolean "predonante_plaquetas"
    t.integer "motivo_rechazo_predonante_plaquetas"
    t.boolean "candidato"
    t.integer "donaciones_count", default: 0
    t.boolean "suscripto"
    t.bigint "ultima_donacion_id"
    t.index ["correo_electronico"], name: "index_donantes_on_correo_electronico"
    t.index ["tipo_documento", "numero_documento"], name: "index_donantes_on_tipo_documento_and_numero_documento"
  end

  create_table "ejecuciones", force: :cascade do |t|
    t.string "ejecutable_type"
    t.bigint "ejecutable_id"
    t.datetime "fecha", default: -> { "CURRENT_TIMESTAMP" }
    t.boolean "ejecutada", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ejecutable_type", "ejecutable_id"], name: "index_ejecuciones_on_ejecutable"
  end

  create_table "exclusiones", force: :cascade do |t|
    t.date "fecha_inicio"
    t.date "fecha_fin"
    t.string "motivo"
    t.bigint "donante_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donante_id"], name: "index_exclusiones_on_donante_id"
  end

  create_table "exclusiones_tipicas", force: :cascade do |t|
    t.integer "duracion"
    t.string "motivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "filtros", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lista_id"
    t.json "parametros"
    t.string "type"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "interacciones", force: :cascade do |t|
    t.bigint "donante_id", null: false
    t.bigint "ejecucion_id", null: false
    t.string "ejecutable_type"
    t.bigint "ejecutable_id"
    t.integer "estado_envio"
    t.integer "estado_interaccion"
    t.string "id_mensaje"
    t.datetime "fecha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "donacion_id"
    t.index ["donante_id"], name: "index_interacciones_on_donante_id"
    t.index ["ejecucion_id"], name: "index_interacciones_on_ejecucion_id"
    t.index ["ejecutable_type", "ejecutable_id"], name: "index_interacciones_on_ejecutable"
  end

  create_table "listas", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plantillas", force: :cascade do |t|
    t.text "nombre"
    t.text "contenido"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reutilizable"
    t.bigint "encabezado_id"
    t.bigint "firma_id"
    t.string "asunto"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["invitation_token"], name: "index_usuarios_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_usuarios_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_usuarios_on_invited_by"
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  end

  add_foreign_key "comunicaciones", "listas"
  add_foreign_key "comunicaciones", "plantillas"
  add_foreign_key "interacciones", "donantes"
  add_foreign_key "interacciones", "ejecuciones"
end
