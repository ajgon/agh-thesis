class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.column :ip, :string, :limit => 15
      t.column :browser_name, :string, :limit => 100
      t.column :browser_version, :string, :limit => 50
      t.column :os_name, :string, :limit => 100
      t.column :os_version, :string, :limit => 50
      t.column :resolution, :string, :limit => 10
      t.column :color_depth, :string, :limit => 2
      t.column :date, :timestamp, :null => false
    end
    execute 'ALTER TABLE statistics CHANGE date date timestamp(14) NOT NULL'
  end

  def self.down
    drop_table :statistics
  end
end
