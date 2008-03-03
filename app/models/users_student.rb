class UsersStudent < ActiveRecord::Base
  belongs_to :user
  belongs_to :speciality
end
