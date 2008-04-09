class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :group, :null => false
      t.references :user, :null => false
    end
    add_index :groups_users, [:group_id, :user_id], :unique => true
  end

  def self.down
    drop_table :groups_users
  end
end
