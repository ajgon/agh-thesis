class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :code, :string, :limit => 80
      t.column :head, :string, :null => false
      t.column :body, :text
    end
  end

  def self.down
    drop_table :groups
  end
end
