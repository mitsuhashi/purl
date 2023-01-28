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

ActiveRecord::Schema.define(version: 2019_02_09_140317) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clone_infos", force: :cascade do |t|
    t.bigint "purl_info_id"
    t.bigint "purl_info_ori_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purl_info_id"], name: "index_clone_infos_on_purl_info_id", unique: true
    t.index ["purl_info_ori_id"], name: "index_clone_infos_on_purl_info_ori_id"
  end

  create_table "domain_history_infos", id: false, force: :cascade do |t|
    t.text "domain_id"
    t.boolean "disable_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "new_flag"
    t.text "name"
    t.boolean "public_flag"
    t.text "maintainer_names"
    t.text "writer_names"
    t.integer "domain_hs_id", null: false
    t.serial "id", null: false
    t.index ["domain_hs_id"], name: "index_domain_history_infos_on_domain_hs_id"
  end

  create_table "domain_infos", force: :cascade do |t|
    t.text "domain_id", null: false
    t.boolean "disable_flag", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "new_flag", default: true, null: false
    t.text "name", null: false
    t.boolean "public_flag", default: false, null: false
    t.index ["domain_id"], name: "domain_infos_idx1", unique: true
    t.index ["name"], name: "index_domain_infos_on_name", unique: true
    t.index ["public_flag"], name: "index_domain_infos_on_public_flag"
  end

  create_table "domain_maintainer_infos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "domain_info_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_info_id"], name: "index_domain_maintainer_infos_on_domain_info_id"
    t.index ["user_id"], name: "index_domain_maintainer_infos_on_user_id"
  end

  create_table "domain_writer_infos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "domain_info_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_info_id"], name: "index_domain_writer_infos_on_domain_info_id"
    t.index ["user_id"], name: "index_domain_writer_infos_on_user_id"
  end

  create_table "group_infos", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_infos_on_group_id"
    t.index ["user_id"], name: "index_group_infos_on_user_id"
  end

  create_table "group_maintainer_infos", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_maintainer_infos_on_group_id"
    t.index ["user_id"], name: "index_group_maintainer_infos_on_user_id"
  end

  create_table "purl_history_infos", id: false, force: :cascade do |t|
    t.text "path"
    t.text "target"
    t.text "see_also_url"
    t.boolean "clone_flag"
    t.boolean "chain_flag"
    t.boolean "disable_flag"
    t.bigint "redirect_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "maintainer_names"
    t.text "symbol"
    t.text "rd_type"
    t.text "clone_path"
    t.bigint "clone_path_id"
    t.integer "purl_hs_id", null: false
    t.serial "id", null: false
    t.index ["purl_hs_id"], name: "index_purl_history_infos_on_purl_hs_id"
  end

  create_table "purl_infos", force: :cascade do |t|
    t.text "path", null: false
    t.text "target"
    t.text "see_also_url"
    t.boolean "clone_flag", default: false, null: false
    t.boolean "chain_flag", default: false, null: false
    t.boolean "disable_flag", default: false, null: false
    t.bigint "redirect_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chain_flag"], name: "purl_info_idx5"
    t.index ["clone_flag"], name: "purl_info_idx4"
    t.index ["disable_flag"], name: "purl_info_idx6"
    t.index ["path"], name: "purl_info_idx1", unique: true
    t.index ["redirect_type_id"], name: "index_purl_infos_on_redirect_type_id"
    t.index ["redirect_type_id"], name: "purl_info_idx7"
    t.index ["see_also_url"], name: "purl_info_idx3"
    t.index ["target"], name: "purl_info_idx2"
  end

  create_table "purl_maintainer_infos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "purl_info_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purl_info_id"], name: "index_purl_maintainer_infos_on_purl_info_id"
    t.index ["user_id"], name: "index_purl_maintainer_infos_on_user_id"
  end

  create_table "redirect_types", force: :cascade do |t|
    t.text "symbol", null: false
    t.text "rd_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "rt_symbol_idx1", unique: true
  end

  create_table "user_history_infos", id: false, force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts"
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "username"
    t.boolean "allowed_to_log_in"
    t.text "affiliation"
    t.text "fullname"
    t.text "justification"
    t.boolean "group_flag"
    t.boolean "admin_flag"
    t.text "comment"
    t.boolean "disable_flag"
    t.boolean "new_flag"
    t.integer "user_hs_id", null: false
    t.serial "id", null: false
    t.text "maintainer_names"
    t.text "member_names"
    t.index ["user_hs_id"], name: "index_user_history_infos_on_user_hs_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "allowed_to_log_in", default: true, null: false
    t.text "affiliation"
    t.text "fullname", null: false
    t.text "justification"
    t.boolean "group_flag", default: false, null: false
    t.boolean "admin_flag"
    t.text "comment"
    t.boolean "disable_flag", null: false
    t.boolean "new_flag", null: false
    t.index ["affiliation"], name: "index_users_on_affiliation"
    t.index ["fullname"], name: "index_users_on_fullname"
    t.index ["group_flag"], name: "index_users_on_group_flag"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "clone_infos", "purl_infos"
  add_foreign_key "clone_infos", "purl_infos", column: "purl_info_ori_id"
  add_foreign_key "domain_maintainer_infos", "domain_infos"
  add_foreign_key "domain_maintainer_infos", "users"
  add_foreign_key "domain_writer_infos", "domain_infos"
  add_foreign_key "domain_writer_infos", "users"
  add_foreign_key "group_infos", "users"
  add_foreign_key "group_infos", "users", column: "group_id"
  add_foreign_key "group_maintainer_infos", "users"
  add_foreign_key "group_maintainer_infos", "users", column: "group_id"
  add_foreign_key "purl_infos", "redirect_types"
  add_foreign_key "purl_maintainer_infos", "purl_infos"
  add_foreign_key "purl_maintainer_infos", "users"
end
