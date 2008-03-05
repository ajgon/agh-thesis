class CreateSubjectsTypes < ActiveRecord::Migration
  def self.up
    create_table :subjects_types do |t|
      t.string :head, :limit => 50, :null => false
      t.boolean :mandatory, :null => false, :default => true
    end
  end

  def self.down
    drop_table :subjects_types
  end
end
