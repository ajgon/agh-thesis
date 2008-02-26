class Group < ActiveRecord::Base
  has_many :groups_users
  has_many :groups_news
  has_many :groups_uploaded_files
end
