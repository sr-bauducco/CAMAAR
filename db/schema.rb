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

ActiveRecord::Schema[8.0].define(version: 2025_02_03_203952) do
  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "school_class_id", null: false
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "teacher_id"
    t.index ["school_class_id"], name: "index_enrollments_on_school_class_id"
    t.index ["teacher_id"], name: "index_enrollments_on_teacher_id"
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "form_templates", force: :cascade do |t|
    t.string "name"
    t.json "questions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "department_id", null: false
    t.index ["department_id"], name: "index_form_templates_on_department_id"
  end

  create_table "forms", force: :cascade do |t|
    t.integer "school_class_id", null: false
    t.integer "form_template_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "target_audience"
    t.index ["form_template_id"], name: "index_forms_on_form_template_id"
    t.index ["school_class_id"], name: "index_forms_on_school_class_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "form_id", null: false
    t.integer "user_id", null: false
    t.json "answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_responses_on_form_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "school_classes", force: :cascade do |t|
    t.integer "subject_id", null: false
    t.string "semester"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_school_classes_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_subjects_on_department_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "registration_number"
    t.integer "role"
    t.integer "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "force_password_change", default: true, null: false
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["registration_number"], name: "index_users_on_registration_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enrollments", "school_classes"
  add_foreign_key "enrollments", "users"
  add_foreign_key "enrollments", "users", column: "teacher_id"
  add_foreign_key "form_templates", "departments"
  add_foreign_key "forms", "form_templates"
  add_foreign_key "forms", "school_classes"
  add_foreign_key "responses", "forms"
  add_foreign_key "responses", "users"
  add_foreign_key "school_classes", "subjects"
  add_foreign_key "subjects", "departments"
  add_foreign_key "users", "departments"
end
