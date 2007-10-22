class CreateUfilesUsers < ActiveRecord::Migration
  def self.up
    create_table :ufiles_users do |t|
      t.column :user_id, :integer, :null => false
      t.column :ufile_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :ufiles_users
  end
end
