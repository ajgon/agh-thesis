class UploadedFile < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user
  has_many :groups_uploaded_files
end
