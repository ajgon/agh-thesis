class DeclarationsExperience < ActiveRecord::Base
  belongs_to :declaration
  belongs_to :speciality
  attr_human_name :student_street => 'Ulica stałego zameldowania'
  attr_human_name :student_postal_code => 'Kod pocztowy stałego zameldowania'
  attr_human_name :student_city => 'Miasto stałego zameldowania'
  attr_human_name :place_name => 'Nazwa zakładu pracy'
  attr_human_name :place_street => 'Ulica zakładu pracy'
  attr_human_name :place_postal_code => 'Kod pocztowy zakładu pracy'
  attr_human_name :place_city => 'Miasto zakładu pracy'
  attr_human_name :beginning => 'Czas rozpoczęcia praktyki'
  validates_presence_of :student_street, :student_postal_code, :student_city, :place_name, :place_street, :place_postal_code, :place_city, :beginning, :message => 'nie może być pustym polem'
end
