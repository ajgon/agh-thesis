class CreateCathedrals < ActiveRecord::Migration
  def self.up
    create_table :cathedrals, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.string :name, :limit => 50, :null => false
   end
   Cathedral.new({'name' => 'Nie podano'}).save!
  end

  def self.down
    drop_table :cathedrals
  end
end
