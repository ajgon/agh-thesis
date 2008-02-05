class CreateUsersStudents < ActiveRecord::Migration
  def self.up
    create_table :users_students do |t|
      t.references :user
      t.string :sgroup, :limit => 7, :null => false
      t.integer :module, :limit => 4, :null => false
      t.integer :sindex, :limit => 6, :null => false
      t.integer :gadu_gadu, :limit => 15
      t.integer :icq, :limit => 15
      t.string :cell, :limit => 15
    end
  end

  def self.down
    drop_table :users_students
  end
end
