class CreateUsersLecturers < ActiveRecord::Migration
  def self.up
    create_table :users_lecturers, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :cathedral, :null => false, :default => 1
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
