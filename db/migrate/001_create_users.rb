class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login, :string, :limit => 50, :null => false
      t.column :password, :string, :limit => 40, :null => false
      t.column :email, :string, :limit => 50, :null => false
      t.column :created_on, :timestamp, :null => false
      t.column :updated_at, :timestamp, :null => false
      t.column :firstname, :string, :limit => 50
      t.column :lastname, :string, :limit => 50
      t.column :privileges, :integer, :null => false
      t.column :question, :text
      t.column :answer, :text
      t.column :www_page, :string, :limit => 200
      t.column :www_description, :text
      t.column :voted, :boolean, :null => false, :default => false
      t.column :signature, :text
      t.column :last_ip, :string, :limit => 15
      t.column :activated, :boolean, :null => false, :default => false
      t.columns << 'kind enum(\'student\', \'lecturer\') NOT NULL'
    end
    execute 'ALTER TABLE users CHANGE created_on created_on timestamp(14) NOT NULL'
    execute 'ALTER TABLE users CHANGE updated_at updated_at timestamp(14) NOT NULL'
  end

  def self.down
    drop_table :users
  end
end
