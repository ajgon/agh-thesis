class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users do |t|
      t.column :user_id, :integer, :null => false
      t.column :group_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :groups_users
  end
end
