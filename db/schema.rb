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
# db/schema.rb

ActiveRecord::Schema[8.0].define(version: 2025_02_14_020843) do
  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_departments_on_name", unique: true
  end

  create_table "enrollments", force: :cascade do |t|
    t.references :user, null: false, foreign_key: { on_delete: :cascade }
    t.references :school_class, null: false, foreign_key: { on_delete: :cascade }
    t.integer "role", null: false, default: 0, comment: "0=student, 1=teacher"
    t.references :teacher, foreign_key: { to_table: :users, on_delete: :nullify }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "school_class_id"], name: "index_enrollments_on_user_and_class", unique: true
  end

  create_table "form_templates", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "questions", null: false, default: {}
    t.references :department, null: false, foreign_key: { on_delete: :cascade }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id", "name"], name: "index_form_templates_on_department_and_name", unique: true
  end

  create_table "forms", force: :cascade do |t|
    t.references :school_class, null: false, foreign_key: { on_delete: :cascade }
    t.references :form_template, null: false, foreign_key: { on_delete: :restrict }
    t.integer "status", null: false, default: 0, comment: "0=draft, 1=published, 2=closed"
    t.integer "target_audience", null: false, comment: "0=students, 1=teachers, 2=all"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_class_id", "form_template_id"], name: "index_forms_on_class_and_template", unique: true
  end

  create_table "responses", force: :cascade do |t|
    t.references :form, null: false, foreign_key: { on_delete: :cascade }
    t.references :user, null: false, foreign_key: { on_delete: :cascade }
    t.jsonb "answers", null: false, default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id", "user_id"], name: "index_responses_on_form_and_user", unique: true
  end

  create_table "school_classes", force: :cascade do |t|
    t.references :subject, null: false, foreign_key: { on_delete: :cascade }
    t.string "semester", null: false, comment: "Format: YYYY.S (e.g., 2024.1)"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id", "semester"], name: "index_school_classes_on_subject_and_semester", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false, comment: "Unique subject code (e.g., MATH101)"
    t.references :department, null: false, foreign_key: { on_delete: :cascade }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_subjects_on_code", unique: true
    t.index ["department_id", "name"], name: "index_subjects_on_department_and_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "registration_number", null: false, comment: "Format: XXXXX-XX"
    t.integer "role", null: false, comment: "0=student, 1=teacher, 2=admin"
    t.references :department, foreign_key: { on_delete: :nullify }
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "force_password_change", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["registration_number"], name: "index_users_on_registration_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end