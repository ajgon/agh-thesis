class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.column :head, :string, :null => false
      t.column :body, :text, :null => false
      t.column :ip, :string, :limit => 15
      t.column :date, :timestamp, :null => false
      t.column :times_readed, :integer, :null => false, :default => 0
      t.column :for_year, :integer, :null => false
    end
    execute 'ALTER TABLE news CHANGE date date timestamp(14) NOT NULL'
  end

  def self.down
    drop_table :news
  end
end
