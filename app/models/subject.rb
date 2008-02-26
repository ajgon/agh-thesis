class Subject < ActiveRecord::Base
  has_many :uploaded_files
end
