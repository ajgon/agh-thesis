class CreateDeclarations < ActiveRecord::Migration
  def self.up
    create_table :declarations do |t|
      t.references :subject, :null => false
      t.references :user, :null => false
      t.datetime :term, :null => false
    end
  end

  def self.down
    drop_table :declarations
  end
end
