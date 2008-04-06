class UsersStudent < ActiveRecord::Base
  belongs_to :user
  belongs_to :speciality
  validates_presence_of :sindex
  validates_numericality_of :sindex
end
