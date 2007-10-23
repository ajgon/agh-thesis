class CreateGroupsNews < ActiveRecord::Migration
  def self.up
    create_table :groups_news do |t|
      t.column :new_id, :integer, :null => false
      t.column :group_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :groups_news
  end
end
