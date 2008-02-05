class CreateCathedrals < ActiveRecord::Migration
  def self.up
    create_table :cathedrals do |t|
      t.string :name, :limit => 20
   end
  end

  def self.down
    drop_table :cathedrals
  end
end
