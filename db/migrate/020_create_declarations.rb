require 'active_record/fixtures'

class CreateDeclarations < ActiveRecord::Migration
  def self.up
    create_table :declarations do |t|
      t.date :available_from, :null => false
      t.date :available_to, :null => false
      t.string :code, :null => false
      t.string :head, :null => false
      t.integer :year, :null => false
    end
    Fixtures.create_fixtures( 
      File.join(File.dirname(__FILE__), '..', '..', 'test', 'fixtures'),
      'declarations'
    )
  end

  def self.down
    drop_table :declarations
  end
end
