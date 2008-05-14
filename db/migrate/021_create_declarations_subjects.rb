require 'active_record/fixtures'

class CreateDeclarationsSubjects < ActiveRecord::Migration
  def self.up
    create_table :declarations_subjects, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.references :declaration, :null => false
      t.references :subject
      t.references :user
      t.integer :price
      t.string :name
      t.decimal :grade, :precision => 2, :scale => 1
      t.integer :year
      t.references :speciality
      t.date :date
      t.string :language, :limit => 4
      t.boolean :print
      t.string :study_type, :limit => 1
      t.integer :study_speciality
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
