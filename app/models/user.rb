class User < ActiveRecord::Base
  has_one :users_lecturer
  has_one :users_student
  has_many :news
  has_many :uploaded_files
  has_many :groups_user
  has_many :polls_questions
end
