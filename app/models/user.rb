require 'digest/sha1'

class User < ActiveRecord::Base
  attr_human_name :pass => 'Hasło'
  attr_human_name :firstname => 'Imię'
  attr_human_name :lastname => 'Nazwisko'
  attr_human_name :pass_confirmation => 'Potwierdzenie hasła'
  has_one :users_lecturer
  has_one :users_student
  has_many :news
  has_many :uploaded_files
  has_many :groups_user
  has_many :polls_questions
  has_many :exams
  validates_presence_of :firstname, :lastname, :login, :pass, :pass_confirmation, :message => 'nie może być pustym polem'
  validates_confirmation_of :pass, :message => 'nie zostało poprawnie potwierdzone'
  validates_uniqueness_of :login, :message => 'już istnieje'
  validates_length_of :pass, :minimum => 6, :message => 'powinno zawierać przynajmniej 6 znaków'
  before_save :set_created_and_updated
  
  def self.authenticate(login, password)
    user = self.find_by_login login
    if user
      expected_password = Digest::SHA1.hexdigest(password)
      unless user.password == expected_password and user.activated
        user = nil
      end
    end
    user
  end
  
  def pass
    @pass
  end
  
  def pass=(pass)
    @pass = pass
    self.password = Digest::SHA1.hexdigest(pass) unless pass.nil? or pass.empty? or pass == '3aed121ab9caaf2e277f716312aa62e67d1d3ba0'
  end
  
  def is_student?
    if self.users_student
      return true
    else
      return false
    end
  end
  
  def is_lecturer?
    if self.users_lecturer
      return true
    else
      return false
    end
  end
  
  private
  def set_created_and_updated
    unless self.created_on
      self.created_on = Time.now
    end
    self.updated_at = Time.now
  end
  
end
