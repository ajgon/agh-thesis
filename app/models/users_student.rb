class UsersStudent < ActiveRecord::Base
  belongs_to :user
  belongs_to :speciality
  validates_presence_of :sindex
  validates_numericality_of :sindex
  
  def year
    return nil unless self.sgroup
    if Time.now.month > 9
      Time.now.year - ('20' + self.sgroup[-3..2]).to_i + 1
    else
      Time.now.year - ('20' + self.sgroup[-3..2]).to_i
    end
  end
    
end
