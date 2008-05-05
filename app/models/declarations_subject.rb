class DeclarationsSubject < ActiveRecord::Base
  belongs_to :declaration
  belongs_to :subject
  belongs_to :speciality
  belongs_to :user
  
  def average
    grades = DeclarationsSubject.find(:all, :conditions => ['declaration_id = ? AND user_id = ?', self.declaration_id, self.user_id]).collect {|i| i.grade.to_f}
    grades.sum / grades.length.to_f
  end
end
