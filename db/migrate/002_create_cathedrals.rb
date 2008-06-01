class CreateCathedrals < ActiveRecord::Migration
  def self.up
    create_table :cathedrals, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.string :name, :limit => 50, :null => false
      t.string :action, :null => false
      t.string :menu_name, :null => false
   end
   Cathedral.new({'name' => 'Nie podano', 'action' => 'none', 'menu_name' => 'brak'}).save!
   Cathedral.new({'name' => 'Katedra Telekomunikacji', 'action' => 'telecommunication', 'menu_name' => 'telekomunikacja'}).save!
   Cathedral.new({'name' => 'Katedra Elektroniki', 'action' => 'electronics', 'menu_name' => 'elektronika'}).save!
   Cathedral.new({'name' => 'Dziekanat', 'action' => 'deanery', 'menu_name' => 'dziekanat'}).save!
   Cathedral.new({'name' => 'Katedra Metrologii', 'action' => 'metrology', 'menu_name' => 'metrologia'}).save!
  end

  def self.down
    drop_table :cathedrals
  end
end
