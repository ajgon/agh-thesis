class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.date :beginning
      t.date :ending, :null => false
      t.string :head, :null => false
      t.integer :for_year, :null => false, :default => 31
      t.string :url
    end
  end

  def self.down
    drop_table :events
  end
end
