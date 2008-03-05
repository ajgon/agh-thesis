class Subject < ActiveRecord::Base
  has_many :uploaded_files
  belongs_to :subjects_type
end
