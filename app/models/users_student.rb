class UsersStudent < ActiveRecord::Base
  belongs_to :user
  belongs_to :speciality
  validates_presence_of :sindex
  validates_numericality_of :sindex
  
  def year
    return nil unless self.sgroup
    extract_year_id(UsersStudent.find(:first, :order => 'sgroup DESC').sgroup) - extract_year_id(self.sgroup) + 1
  end
  
  private
  def extract_year_id sgroup
    sgroup.gsub(/[^0-9]/, '')[0..1].to_i
  end
  
end
