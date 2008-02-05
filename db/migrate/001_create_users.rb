class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :limit => 50, :null => false
      t.string :password, :limit => 40, :null => false
      t.string :email, :limit => 50, :null => false
      t.date :created_on, :null => false
      t.datetime :updated_at, :null => false
      t.string :firstname, :limit => 50
      t.string :lastname, :limit => 50
      t.integer :privileges, :null => false
      t.text :question
      t.text :answer
      t.string :www_page, :limit => 200
      t.text :www_description
      t.boolean :voted, :null => false, :default => false
      t.string :kind, :limit => 20, :null => false  # student/lecturer/absolvent
      t.text :signature
      t.string :last_ip, :limit => 15, :null => false
      t.boolean :activated, :null => false, :default => false
    end
  end

  def self.down
    drop_table :users
  end
end
