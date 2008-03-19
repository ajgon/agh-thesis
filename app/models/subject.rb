class Subject < ActiveRecord::Base
  has_many :uploaded_files
  has_many :exams
  belongs_to :subjects_type
end
