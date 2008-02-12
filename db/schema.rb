# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 13) do

  create_table "cathedrals", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "groups", :force => true do |t|
    t.string "code", :limit => 80
    t.string "head",               :null => false
    t.text   "body"
  end

  create_table "groups_news", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "new_id"
  end

  add_index "groups_news", ["group_id"], :name => "group_id"
  add_index "groups_news", ["new_id"], :name => "new_id"

  create_table "groups_uploaded_files", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "uploaded_file_id"
  end

  add_index "groups_uploaded_files", ["group_id"], :name => "group_id"
  add_index "groups_uploaded_files", ["uploaded_file_id"], :name => "uploaded_file_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["group_id"], :name => "group_id"
  add_index "groups_users", ["user_id"], :name => "user_id"

  create_table "news", :force => true do |t|
    t.integer "news_type_id"
    t.integer "user_id"
    t.string  "head",                                      :null => false
    t.text    "body",                                      :null => false
    t.string  "ip",           :limit => 15
    t.date    "datetime",                                  :null => false
    t.integer "times_readed",               :default => 0, :null => false
    t.integer "for_year",                                  :null => false
  end

  add_index "news", ["news_type_id"], :name => "news_type_id"
  add_index "news", ["user_id"], :name => "user_id"

  create_table "news_types", :force => true do |t|
    t.string "name", :limit => 20, :null => false
  end

  create_table "subjects", :force => true do |t|
    t.string "head", :null => false
    t.text   "body"
  end

  create_table "subjects_users", :id => false, :force => true do |t|
    t.integer "subject_id"
    t.integer "user_id"
  end

  add_index "subjects_users", ["subject_id"], :name => "subject_id"
  add_index "subjects_users", ["user_id"], :name => "user_id"

  create_table "uploaded_files", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "user_id"
    t.string   "filename",                 :null => false
    t.string   "head",                     :null => false
    t.text     "body"
    t.datetime "date",                     :null => false
    t.string   "kind",       :limit => 15
  end

  add_index "uploaded_files", ["subject_id"], :name => "subject_id"
  add_index "uploaded_files", ["user_id"], :name => "user_id"

  create_table "users", :force => true do |t|
    t.string   "login",           :limit => 50,                                                          :null => false
    t.string   "password",        :limit => 40,  :default => "da39a3ee5e6b4b0d3255bfef95601890afd80709", :null => false
    t.string   "email",           :limit => 50
    t.date     "created_on",                                                                             :null => false
    t.datetime "updated_at",                                                                             :null => false
    t.string   "firstname",       :limit => 50
    t.string   "lastname",        :limit => 50
    t.integer  "privileges",                     :default => 0,                                          :null => false
    t.text     "question"
    t.text     "answer"
    t.string   "www_page",        :limit => 200
    t.text     "www_description"
    t.boolean  "voted",                          :default => false,                                      :null => false
    t.string   "kind",            :limit => 20,                                                          :null => false
    t.text     "signature"
    t.string   "last_ip",         :limit => 15
    t.boolean  "activated",                      :default => false,                                      :null => false
  end

  create_table "users_lecturers", :force => true do |t|
    t.integer "cathedral_id"
    t.integer "user_id",                     :null => false
    t.string  "place",         :limit => 30
    t.string  "title",         :limit => 50
    t.string  "consultations", :limit => 50
    t.string  "phone",         :limit => 15
    t.string  "photo",         :limit => 50
  end

  add_index "users_lecturers", ["cathedral_id"], :name => "cathedral_id"
  add_index "users_lecturers", ["user_id"], :name => "user_id"

  create_table "users_students", :force => true do |t|
    t.integer "user_id",                 :null => false
    t.string  "sgroup",    :limit => 7,  :null => false
    t.integer "module",    :limit => 4,  :null => false
    t.integer "sindex",    :limit => 6,  :null => false
    t.integer "gadu_gadu", :limit => 15
    t.integer "icq",       :limit => 15
    t.string  "cell",      :limit => 15
  end

  add_index "users_students", ["user_id"], :name => "user_id"

  add_foreign_key "groups_news", ["group_id"], "groups", ["id"], :name => "groups_news_ibfk_1"
  add_foreign_key "groups_news", ["new_id"], "news", ["id"], :name => "groups_news_ibfk_2"

  add_foreign_key "groups_uploaded_files", ["group_id"], "groups", ["id"], :name => "groups_uploaded_files_ibfk_1"
  add_foreign_key "groups_uploaded_files", ["uploaded_file_id"], "uploaded_files", ["id"], :name => "groups_uploaded_files_ibfk_2"

  add_foreign_key "groups_users", ["group_id"], "groups", ["id"], :name => "groups_users_ibfk_1"
  add_foreign_key "groups_users", ["user_id"], "users", ["id"], :name => "groups_users_ibfk_2"

  add_foreign_key "news", ["news_type_id"], "news_types", ["id"], :name => "news_ibfk_1"
  add_foreign_key "news", ["user_id"], "users", ["id"], :name => "news_ibfk_2"

  add_foreign_key "subjects_users", ["subject_id"], "subjects", ["id"], :name => "subjects_users_ibfk_1"
  add_foreign_key "subjects_users", ["user_id"], "users", ["id"], :name => "subjects_users_ibfk_2"

  add_foreign_key "uploaded_files", ["subject_id"], "subjects", ["id"], :name => "uploaded_files_ibfk_1"
  add_foreign_key "uploaded_files", ["user_id"], "users", ["id"], :name => "uploaded_files_ibfk_2"

  add_foreign_key "users_lecturers", ["cathedral_id"], "cathedrals", ["id"], :name => "users_lecturers_ibfk_1"
  add_foreign_key "users_lecturers", ["user_id"], "users", ["id"], :name => "users_lecturers_ibfk_2"

  add_foreign_key "users_students", ["user_id"], "users", ["id"], :name => "users_students_ibfk_1"

end
