class CreateUsersLecturers < ActiveRecord::Migration
  def self.up
    create_table :users_lecturers do |t|
      t.references :cathedral
      t.references :user, :null => false
      t.string :place, :limit => 30
      t.string :title, :limit => 50
      t.string :consultations, :limit => 50
      t.string :phone, :limit => 15
      t.string :photo, :limit => 50
    end
  end

  def self.down
    drop_table :users_lecturers
  end
end
