class UploadedFile < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user
  has_many :groups_uploaded_files
  
  def self.is_public? file_id
    GroupsUploadedFile.find(:first, :conditions => ['uploaded_file_id = ?', file_id]).nil?
  end
  
end
