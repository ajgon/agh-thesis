class UploadedFile < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user
  has_many :groups_uploaded_files
  
  def self.is_public? file_id
    GroupsUploadedFile.find(:first, :conditions => ['uploaded_file_id = ?', file_id]).nil?
  end
  
  def self.find_materials_for_user(id, kind = '', include_all_logged = true)
    unless kind.nil? or kind.empty?
      kind = " AND kind = '#{kind.to_s}'"
    end
    user_groups = self.acquire_groups id
    user_groups.push(1) if include_all_logged
    if user_groups.empty?
      return []
    end
    return UploadedFile.find(:all, :include => [:groups_uploaded_files, :subject, :user], :conditions => "groups_uploaded_files.group_id IN (#{user_groups.join(', ')})#{kind}", :order => 'subject_id')
  end
  
  def self.can_user_get_file? user_id, file_id
    user_groups = self.acquire_groups user_id
    user_groups.push(1)
    if self.is_public? file_id
      return true
    end
    allowed = false
    GroupsUploadedFile.find(:all, :conditions => ['uploaded_file_id = ?', file_id]).each do |groups|
      allowed = true if user_groups.include? groups.group_id.to_i
    end
    return allowed
  end
  
  private
  def self.acquire_groups id
    user_groups = []
    GroupsUser.find(:all, :conditions => ['user_id = ?', id]).each {|groups_user| user_groups.push groups_user.group_id}
    return user_groups
  end
  
end
