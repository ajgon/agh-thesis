require 'active_record/fixtures'

class CreateDeclarationsSubjects < ActiveRecord::Migration
  def self.up
    create_table :declarations_subjects do |t|
      t.references :declaration, :null => false
      t.references :subject, :null => false
      t.references :user
      t.integer :price
      t.string :name
      t.integer :grade
      t.integer :year
      t.string :module, :limit => 1
      t.date :date
      t.string :language, :limit => 4
      t.boolean :print
    end
    Fixtures.create_fixtures( 
      File.join(File.dirname(__FILE__), '..', '..', 'test', 'fixtures'),
      'declarations_subjects'
    )
  end

  def self.down
    drop_table :declarations_subjects
  end
end
