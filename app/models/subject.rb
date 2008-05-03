class Subject < ActiveRecord::Base
  has_many :uploaded_files
  has_many :exams
  has_many :declarations_subjects
  has_many :news
  belongs_to :subjects_type
  
  def year
    (self.season / 2.0).ceil
  end
  
  def count_for_declaration declaration_id
    DeclarationsSubject.count(:conditions => ['subject_id = ? AND declaration_id = ? AND user_id IS NOT NULL', self.id, declaration_id])
  end
  
  def count_declarations
    DeclarationsSubject.count(:conditions => ['subject_id = ? AND price IS NULL AND name IS NULL AND user_id IS NOT NULL', self.id])
  end
end
