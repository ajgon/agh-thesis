class UsersStudent < ActiveRecord::Migration
  def self.up
    create_table :users_students do |t|
      t.column :users_id, :integer, :null => false
      t.column :group, :string, :limit => 4, :null => false
      t.column :module, :integer, :limit => 4, :null => false
      t.column :new_group, :string, :limit => 6, :null => false
      t.column :index, :integer, :limit => 6, :null => false
      t.column :gadu_gadu, :integer, :limit => 15
      t.column :icq, :integer, :limit => 15
      t.column :cell, :string, :limit => 15
    end
  end

  def self.down
    drop_table :users_students
  end
end
