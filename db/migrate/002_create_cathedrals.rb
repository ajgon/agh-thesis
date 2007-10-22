class CreateCathedrals < ActiveRecord::Migration
  def self.up
    create_table :cathedrals do |t|
      t.column :name, :string, :limit => 20
    end
  end

  def self.down
    drop_table :cathedrals
  end
end
