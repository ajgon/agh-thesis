class UsersLecturer < ActiveRecord::Migration
  def self.up
    create_table :users_lecturers do |t|
      t.column :users_id, :integer, :null => false
      t.column :place, :string, :limit => 30
      t.column :title, :string, :limit => 50
      t.column :cathedral, :integer, :limit => 4
      t.column :consultations, :string, :limit => 50
      t.column :phone, :string, :limit => 15
      t.column :photo, :string, :limit => 50
    end
  end

  def self.down
    drop_table :users_lecturers
  end
end
