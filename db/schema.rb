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

ActiveRecord::Schema.define(:version => 22) do

  create_table "cathedrals", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "declarations", :force => true do |t|
    t.date    "available_from", :null => false
    t.date    "available_to",   :null => false
    t.string  "code",           :null => false
    t.string  "head",           :null => false
    t.integer "year",           :null => false
    t.integer "how_many"
  end

  create_table "declarations_experiences", :force => true do |t|
    t.integer  "declaration_id",                                       :null => false
    t.string   "firstname",                                            :null => false
    t.string   "lastname",                                             :null => false
    t.integer  "sindex",               :limit => 6,                    :null => false
    t.integer  "speciality_id",                                        :null => false
    t.string   "student_street",                                       :null => false
    t.string   "student_postal_code",                                  :null => false
    t.string   "student_city",                                         :null => false
    t.string   "place_name",                                           :null => false
    t.string   "place_street",                                         :null => false
    t.string   "place_postal_code",                                    :null => false
    t.string   "place_city",                                           :null => false
    t.date     "beginning",                                            :null => false
    t.date     "beginning_additional"
    t.date     "ending_additional"
    t.boolean  "dormitory",                         :default => false, :null => false
    t.string   "policy_type"
    t.string   "policy_name"
    t.string   "policy_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "declarations_experiences", ["declaration_id"], :name => "declaration_id"
  add_index "declarations_experiences", ["speciality_id"], :name => "speciality_id"

  create_table "declarations_subjects", :force => true do |t|
    t.integer "declaration_id",              :null => false
    t.integer "subject_id",                  :null => false
    t.integer "user_id"
    t.integer "price"
    t.string  "name"
    t.integer "grade"
    t.integer "year"
    t.integer "speciality_id"
    t.date    "date"
    t.string  "language",       :limit => 4
    t.boolean "print"
  end

  add_index "declarations_subjects", ["declaration_id"], :name => "declaration_id"
  add_index "declarations_subjects", ["subject_id"], :name => "subject_id"
  add_index "declarations_subjects", ["user_id"], :name => "user_id"
  add_index "declarations_subjects", ["speciality_id"], :name => "speciality_id"

  create_table "events", :force => true do |t|
    t.date    "beginning"
    t.date    "ending",                    :null => false
    t.string  "head",                      :null => false
    t.integer "for_year",  :default => 31, :null => false
    t.string  "url"
  end

  create_table "exams", :force => true do |t|
    t.integer  "subject_id",                 :null => false
    t.integer  "user_id",                    :null => false
    t.string   "exams_name_id", :limit => 3, :null => false
    t.string   "examiner",                   :null => false
    t.datetime "date",                       :null => false
    t.string   "place",                      :null => false
    t.integer  "term",                       :null => false
  end

  add_index "exams", ["subject_id"], :name => "subject_id"
  add_index "exams", ["user_id"], :name => "user_id"
  add_index "exams", ["exams_name_id"], :name => "exams_name_id"

  create_table "exams_names", :force => true do |t|
    t.string "head"
  end

  add_index "exams_names", ["id"], :name => "index_exams_names_on_id", :unique => true

  create_table "groups", :force => true do |t|
    t.integer "user_id"
    t.string  "head",    :null => false
    t.text    "body"
  end

  add_index "groups", ["user_id"], :name => "user_id"

  create_table "groups_news", :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "news_id",  :null => false
  end

  add_index "groups_news", ["group_id"], :name => "group_id"
  add_index "groups_news", ["news_id"], :name => "news_id"

  create_table "groups_uploaded_files", :force => true do |t|
    t.integer "group_id",         :default => 2, :null => false
    t.integer "uploaded_file_id",                :null => false
  end

  add_index "groups_uploaded_files", ["group_id"], :name => "group_id"
  add_index "groups_uploaded_files", ["uploaded_file_id"], :name => "uploaded_file_id"

  create_table "groups_users", :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "user_id",  :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "index_groups_users_on_group_id_and_user_id", :unique => true
  add_index "groups_users", ["user_id"], :name => "user_id"

  create_table "news", :force => true do |t|
    t.integer  "news_type_id"
    t.integer  "user_id",                                   :null => false
    t.integer  "subject_id"
    t.string   "head",                                      :null => false
    t.text     "body",                                      :null => false
    t.string   "ip",           :limit => 15
    t.datetime "date"
    t.integer  "times_readed",               :default => 0, :null => false
    t.integer  "for_year",                                  :null => false
  end

  add_index "news", ["news_type_id"], :name => "news_type_id"
  add_index "news", ["user_id"], :name => "user_id"
  add_index "news", ["subject_id"], :name => "subject_id"

  create_table "news_types", :force => true do |t|
    t.string "name", :limit => 20, :null => false
  end

  create_table "polls_answers", :force => true do |t|
    t.integer "polls_question_id",                               :null => false
    t.string  "answer",            :limit => 200,                :null => false
    t.integer "quantity",                         :default => 0, :null => false
  end

  add_index "polls_answers", ["polls_question_id"], :name => "polls_question_id"

  create_table "polls_questions", :force => true do |t|
    t.integer  "user_id",                                      :null => false
    t.string   "question",   :limit => 200,                    :null => false
    t.datetime "start_time",                                   :null => false
    t.datetime "end_time"
    t.boolean  "anonymous",                 :default => false, :null => false
  end

  add_index "polls_questions", ["user_id"], :name => "user_id"

  create_table "specialities", :force => true do |t|
    t.string "head", :limit => 50, :null => false
  end

  create_table "subjects", :force => true do |t|
    t.integer "subjects_type_id"
    t.string  "acronym",          :limit => 10,                :null => false
    t.string  "head",                                          :null => false
    t.text    "body"
    t.string  "code",             :limit => 6
    t.integer "season",           :limit => 4,  :default => 0, :null => false
  end

  add_index "subjects", ["subjects_type_id"], :name => "subjects_type_id"

  create_table "subjects_types", :force => true do |t|
    t.string  "head",      :limit => 50,                   :null => false
    t.boolean "mandatory",               :default => true, :null => false
  end

  create_table "uploaded_files", :force => true do |t|
    t.integer  "subject_id",                               :null => false
    t.integer  "user_id",                                  :null => false
    t.integer  "uploader_id",                              :null => false
    t.string   "filename",                                 :null => false
    t.string   "head",                                     :null => false
    t.text     "body"
    t.datetime "date",                                     :null => false
    t.string   "kind",        :limit => 15
    t.integer  "downloads",                 :default => 0, :null => false
  end

  add_index "uploaded_files", ["subject_id"], :name => "subject_id"
  add_index "uploaded_files", ["user_id"], :name => "user_id"
  add_index "uploaded_files", ["uploader_id"], :name => "uploader_id"

  create_table "users", :force => true do |t|
    t.string   "login",           :limit => 50
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
    t.text     "signature"
    t.string   "last_ip",         :limit => 15
    t.boolean  "activated",                      :default => false,                                      :null => false
  end

  create_table "users_lecturers", :force => true do |t|
    t.integer "cathedral_id",                :default => 1, :null => false
    t.integer "user_id",                                    :null => false
    t.string  "place",         :limit => 30
    t.string  "title",         :limit => 50
    t.string  "consultations", :limit => 50
    t.string  "phone",         :limit => 15
    t.string  "photo",         :limit => 50
  end

  add_index "users_lecturers", ["cathedral_id"], :name => "cathedral_id"
  add_index "users_lecturers", ["user_id"], :name => "user_id"

  create_table "users_students", :force => true do |t|
    t.integer "user_id",                     :null => false
    t.integer "speciality_id",               :null => false
    t.string  "sgroup",        :limit => 7,  :null => false
    t.integer "sindex",        :limit => 6,  :null => false
    t.integer "gadu_gadu",     :limit => 15
    t.integer "icq",           :limit => 15
    t.string  "cell",          :limit => 15
  end

  add_index "users_students", ["user_id"], :name => "user_id"
  add_index "users_students", ["speciality_id"], :name => "speciality_id"

  add_foreign_key "declarations_experiences", ["declaration_id"], "declarations", ["id"], :name => "declarations_experiences_ibfk_1"
  add_foreign_key "declarations_experiences", ["speciality_id"], "specialities", ["id"], :name => "declarations_experiences_ibfk_2"

  add_foreign_key "declarations_subjects", ["declaration_id"], "declarations", ["id"], :name => "declarations_subjects_ibfk_1"
  add_foreign_key "declarations_subjects", ["subject_id"], "subjects", ["id"], :name => "declarations_subjects_ibfk_2"
  add_foreign_key "declarations_subjects", ["user_id"], "users", ["id"], :name => "declarations_subjects_ibfk_3"
  add_foreign_key "declarations_subjects", ["speciality_id"], "specialities", ["id"], :name => "declarations_subjects_ibfk_4"

  add_foreign_key "exams", ["subject_id"], "subjects", ["id"], :name => "exams_ibfk_1"
  add_foreign_key "exams", ["user_id"], "users", ["id"], :name => "exams_ibfk_2"
  add_foreign_key "exams", ["exams_name_id"], "exams_names", ["id"], :name => "exams_ibfk_3"

  add_foreign_key "groups", ["user_id"], "users", ["id"], :name => "groups_ibfk_1"

  add_foreign_key "groups_news", ["group_id"], "groups", ["id"], :name => "groups_news_ibfk_1"
  add_foreign_key "groups_news", ["news_id"], "news", ["id"], :name => "groups_news_ibfk_2"

  add_foreign_key "groups_uploaded_files", ["group_id"], "groups", ["id"], :name => "groups_uploaded_files_ibfk_1"
  add_foreign_key "groups_uploaded_files", ["uploaded_file_id"], "uploaded_files", ["id"], :name => "groups_uploaded_files_ibfk_2"

  add_foreign_key "groups_users", ["group_id"], "groups", ["id"], :name => "groups_users_ibfk_1"
  add_foreign_key "groups_users", ["user_id"], "users", ["id"], :name => "groups_users_ibfk_2"

  add_foreign_key "news", ["news_type_id"], "news_types", ["id"], :name => "news_ibfk_1"
  add_foreign_key "news", ["user_id"], "users", ["id"], :name => "news_ibfk_2"
  add_foreign_key "news", ["subject_id"], "subjects", ["id"], :name => "news_ibfk_3"

  add_foreign_key "polls_answers", ["polls_question_id"], "polls_questions", ["id"], :name => "polls_answers_ibfk_1"

  add_foreign_key "polls_questions", ["user_id"], "users", ["id"], :name => "polls_questions_ibfk_1"

  add_foreign_key "subjects", ["subjects_type_id"], "subjects_types", ["id"], :name => "subjects_ibfk_1"

  add_foreign_key "uploaded_files", ["subject_id"], "subjects", ["id"], :name => "uploaded_files_ibfk_1"
  add_foreign_key "uploaded_files", ["user_id"], "users", ["id"], :name => "uploaded_files_ibfk_2"
  add_foreign_key "uploaded_files", ["uploader_id"], "users", ["id"], :name => "uploaded_files_ibfk_3"

  add_foreign_key "users_lecturers", ["cathedral_id"], "cathedrals", ["id"], :name => "users_lecturers_ibfk_1"
  add_foreign_key "users_lecturers", ["user_id"], "users", ["id"], :name => "users_lecturers_ibfk_2"

  add_foreign_key "users_students", ["user_id"], "users", ["id"], :name => "users_students_ibfk_1"
  add_foreign_key "users_students", ["speciality_id"], "specialities", ["id"], :name => "users_students_ibfk_2"

end
