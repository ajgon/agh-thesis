class Speciality < ActiveRecord::Base
  has_many :users_students
  has_many :declarations_subjects
  has_many :declarations_experiences
end
