class CreateCathedrals < ActiveRecord::Migration
  def self.up
    create_table :cathedrals do |t|
      t.string :name, :limit => 50, :null => false
   end
  end

  def self.down
    drop_table :cathedrals
  end
end
