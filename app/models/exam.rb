class Exam < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject
  belongs_to :exams_name
end
