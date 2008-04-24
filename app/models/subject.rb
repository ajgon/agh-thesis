class Subject < ActiveRecord::Base
  has_many :uploaded_files
  has_many :exams
  has_many :declarations
  has_many :news
  belongs_to :subjects_type
  
  def year
    (self.season / 2.0).ceil
  end
end
