class GroupsUploadedFile < ActiveRecord::Base
  belongs_to :group
  belongs_to :uploaded_file
end
