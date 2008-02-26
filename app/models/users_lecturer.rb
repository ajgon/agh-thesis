class UsersLecturer < ActiveRecord::Base
  belongs_to :user
  belongs_to :cathedral
end
