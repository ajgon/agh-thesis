require 'active_record/fixtures'

class CreateExamsNames < ActiveRecord::Migration
  def self.up
    create_table :exams_names, :id => false, :options => 'character set utf8 collate utf8_polish_ci engine InnoDB' do |t|
      t.string :id, :limit => 3
      t.string :head
    end
    add_index :exams_names, :id, :unique => true
    Fixtures.create_fixtures( 
      File.join(File.dirname(__FILE__), '..', '..', 'test', 'fixtures'),
      'exams_names'
    )
  end

  def self.down
    drop_table :exams_names
  end
end
