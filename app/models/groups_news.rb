class GroupsNews < ActiveRecord::Base
  belongs_to :group
  belongs_to :news
end
