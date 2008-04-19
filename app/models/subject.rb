class Subject < ActiveRecord::Base
  has_many :uploaded_files
  has_many :exams
  has_many :declarations
  has_many :news
  belongs_to :subjects_type
end
