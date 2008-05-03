class Declaration < ActiveRecord::Base
  has_many :declarations_subjects
  
  def how_many? speciality_id
    case speciality_id
    when 2
      self.how_many.to_i / 10
    when 3
      self.how_many.to_i % 10
    else
      0
    end
  end
end
