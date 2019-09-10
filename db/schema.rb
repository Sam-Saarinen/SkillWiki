# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_18_192310) do

  create_table "assignments", force: :cascade do |t|
    t.integer "student_id"
    t.integer "classroom_id"
    t.integer "teacher_id"
    t.integer "topic_id"
    t.datetime "due_date"
    t.text "resources_completed"
    t.datetime "start_date"
    t.float "quiz_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_assignments_on_classroom_id"
    t.index ["student_id"], name: "index_assignments_on_student_id"
    t.index ["teacher_id"], name: "index_assignments_on_teacher_id"
    t.index ["topic_id"], name: "index_assignments_on_topic_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.text "name"
    t.text "students"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "stats"
    t.string "join_code"
    t.index ["join_code"], name: "index_classrooms_on_join_code", unique: true
    t.index ["user_id"], name: "index_classrooms_on_user_id"
  end

  create_table "classrooms_users", id: false, force: :cascade do |t|
    t.integer "classroom_id"
    t.integer "user_id"
    t.index ["classroom_id"], name: "index_classrooms_users_on_classroom_id"
    t.index ["user_id"], name: "index_classrooms_users_on_user_id"
  end

  create_table "interactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "resource_id"
    t.integer "topic_id"
    t.integer "helpful_q"
    t.integer "confidence_q"
    t.float "time_taken"
    t.boolean "reported", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_interactions_on_resource_id"
    t.index ["topic_id"], name: "index_interactions_on_topic_id"
    t.index ["user_id"], name: "index_interactions_on_user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_recommendations_on_topic_id"
    t.index ["user_id"], name: "index_recommendations_on_user_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.integer "topic_id"
    t.integer "user_id"
    t.boolean "approved", default: false
    t.text "content"
    t.boolean "tentative", default: true
    t.boolean "removed", default: false
    t.boolean "flagged", default: false
    t.integer "views", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "helpful_avg", default: 0.0
    t.integer "feedback_count", default: 0
    t.float "sampled_reward", default: 0.0
    t.index ["topic_id"], name: "index_resources_on_topic_id"
    t.index ["user_id"], name: "index_resources_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.boolean "approved", default: false
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reviewed", default: false
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.boolean "admin"
    t.boolean "teacher"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "speed"
    t.integer "guide"
    t.text "badges"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
