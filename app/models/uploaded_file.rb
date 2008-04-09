class UploadedFile < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user
  has_many :groups_uploaded_files
  
  def self.is_public? file_id
    GroupsUploadedFile.find(:first, :conditions => ['uploaded_file_id = ?', file_id]).nil?
  end
  
  def self.find_materials_for_user(id, kind = '', include_non_logged = true)
    unless kind.nil? or kind.empty?
      kind = " AND kind = '#{kind.to_s}'"
    end
    user_groups = []
    user_groups = [1] if include_non_logged
    GroupsUser.find(:all, :conditions => ['user_id = ?', id]).each {|groups_user| user_groups.push groups_user.group_id}
    return UploadedFile.find(:all, :include => :groups_uploaded_files, :conditions => "groups_uploaded_files.group_id IN (#{user_groups.join(', ')})#{kind}")
  end
end
